/*
  This module implements the algorithm from "A Prettier Printer"
  by Philip Wadler.
 */
{ stdlib, ... }:
let
  lib = stdlib;
  pretty = rec {
    # ----------------------- Helpers -----------------------
    /**
      Iterates over a DOCument structure

      There are 4 cases:
        null
        Text { string, rest }
        Line { indent, rest }
        Union { left, right }

      # Type:
      ```
      DOCIter: DOC ->
               any ->
               (string -> DOC -> any) ->
               (int -> DOC -> any) ->
               (DOC -> DOC -> any) -> any
      ```
      */
    DOCIter = doc: nullcase: textcase: linecase: unioncase:
      if doc == null then nullcase
      else if doc ? text then textcase (doc.text.string) (doc.text.rest)
      else if doc ? line then linecase (doc.line.indent) (doc.line.rest)
      else if doc ? union then unioncase (doc.union.left) (doc.union.right)
      else throw "Invalid document structure: ${doc}";


    /**
       Iterates over a doc structure

       there are 6 cases to consider:
         null
         concat { left, right }
         nest { level, doc }
         text { string }
         line { alternative }
         union { left, right }
      # Type:
      ```
      docIter: doc ->
               any ->
               (doc -> doc -> any) ->
               (int -> doc -> any) ->
               (string -> any) ->
               (string -> any) ->
               (doc -> doc -> any) ->
               any
      ```
      */
    docIter = doc: nullcase: concatcase: nestcase: textcase: linecase: unioncase:
      if doc == null then nullcase
      else if doc ? concat then concatcase (doc.concat.left) (doc.concat.right)
      else if doc ? nest then nestcase (doc.nest.level) (doc.nest.doc)
      else if doc ? text then textcase (doc.text.string)
      else if doc ? line then linecase (doc.line.alternative)
      else if doc ? union then unioncase (doc.union.left) (doc.union.right)
      else throw "Invalid DOC structure: ${doc}";



    # ---------------------- Document Constructors ---------------------
    /**
      Concatenates two documents

      # Type:
      ````
      concat: doc -> doc -> doc
      ````
      */
    concat = left: right: { concat = { inherit left right; }; };

    /**
      Concatenates a list of documents

      # Type:
      ```
      sequence :: [doc] -> doc
      ```
      */
    sequence = xs: lib.foldr concat null xs;

    /**
      Represents an empty document and/or the end of a document
      */
    end = null;

    /**
      Creates a text section in a DOCument

      # Type:
      ```
      Text: string -> DOC -> DOC
      ```

      # Example:
      ```
      doc1 = Text "Hello!" end;
      doc2 = Text "Hello, " (Line (Text "world!" end));
      ```
      */
    Text = string: rest: { text = { inherit string rest; }; };

    /**
      Creates a document with a single section of text
      # Type:
      ```
      text: string -> doc
      ```
      */
    text = string: { text = { inherit string; }; };

    /**
      Prepends a linebreak to a DOCument

      # Type:
      ```
      Line: int -> DOC -> DOC
      ```
      */
    Line = indent: rest: { line = { inherit indent rest; }; };

    /**
      Creates a document consisting of a single line break

      # Type:
      ```
      line: doc
      ```
      */
    line = { line = { alternative = " "; }; };

    /**
      Creates a line break with an alternative text to use if the
      line break is flattened

      # Type:
      ```
      lineWithAlt: string -> doc
      ```
      */
    lineWithAlt = alternative: { line = { alternative = alternative; }; };

    /**
      Creates a line break that *must* be rendered as a line break

      # Type:
      ```
      hardbreak: doc
      ```
      */
    hardline = { line = { alternative = null; }; };

    /**
      Creates a union of two alternate DOCuments

      # Type
      ```
      Union :: DOC -> DOC -> DOC
      ```
      */
    Union = left: right: { union = { inherit left right; }; };

    /**
      Creates a union of two alternate documents

      # Type
      ```
      union :: doc -> doc -> doc
      ```
      */
    union = left: right: { union = { inherit left right; }; };

    /**
      Indents all lines in a document by a given number of spaces

      # Type:
      ```
      next: int -> doc -> doc
      ```
      */
    nest = level: doc: { nest = { inherit level doc; }; };

    /**
      Checks if a document has any hard line breaks
      */
    hasHardLines = doc:
      docIter doc
        /* null => */ false
        /* concat => */ (left: right: hasHardLines left || hasHardLines right)
        /* nest => */ (level: rest: hasHardLines rest)
        /* text => */ (string: false)
        /* line => */ (alternative: alternative == null)
        /* union => */ (left: right: hasHardLines left);

    /**
      Creates two alternate documents, one of which has all lines flattened

      # Type:
      ```
      group :: doc -> doc
      ```
      */
    group = doc:
      if hasHardLines doc
      then doc
      else union (flatten doc) doc;

    /**
      Turns a DOCument into a string. The document must not contain unions.

      # Type
      ```
      layout :: DOC -> string
      ```
      */
    layout = doc:
      DOCIter doc
        /* null => */ ""
        /* text => */ (string: rest: string + layout rest)
        /* line => */ (indent: rest: "\n" + lib.strings.replicate indent " " + layout rest)
        /* union => */ (left: right: throw "layout called on a union document, use pretty instead");

    /**
      Flattens a document by removing all line breaks

      # Type
      ```
      flatten :: doc -> doc
      ```
      */
    flatten = doc:
      docIter doc
        /* null => */ null
        /* concat => */ (left: right: concat (flatten left) (flatten right))
        /* nest => */ (level: rest: (flatten rest))
        /* text => */ (string: text string)
        /* line => */ (alternative: text alternative)
        /* union => */ (left: right: flatten left);

    /**
      Iteration function for finding the best layout of a given document

      Produces a DOCument that best fits the given width.

      Maintains a list of documents to consider in its final argument.

      # Type
      ```
      be :: int -> int -> [ { indent: int; doc: doc; } ] -> DOC
      ```
      */
    be = width: curCols: zs:
      if zs == [] then null
      else let
        z = lib.lists.head zs;
        zzs = lib.lists.tail zs;
        doc = z.doc;
        indent = z.indent;
      in docIter doc
        /* null => */ (be width curCols zzs)
        /* concat => */ (left: right: be width curCols ([{ indent = indent; doc = left; } { indent = indent; doc = right; }] ++ zzs))
        /* nest => */ (level: doc: be width curCols ([{ indent = indent + level; doc = doc; }] ++ zzs))
        /* text => */ (string: Text string (be width (curCols + builtins.stringLength string) zzs))
        /* line => */ (alternative: Line indent (be width indent zzs)) # TODO: implement alternative
        /* union => */ (left: right: better width curCols (be width curCols ([{ indent = indent; doc = left; }] ++ zzs))
                                                          (be width curCols ([{ indent = indent; doc = right; }] ++ zzs)));

    /**
      Finds the best layout for a document given a preferred maximum line width
      and the current number of columns used.

      # Type
      ```
      best :: int -> int -> doc -> DOC
      ```
      */
    best = width: curCols: doc: be width curCols [{ indent = 0; doc = doc; }];

    /**
      Compares two DOCuments and returns the one that is a better fit for the
      constraints.

      This function assumes an order on the documents where the initial line of the left
      document is always at least as long asa the right.

      # Type
      ```
      better :: int -> int -> DOC -> DOC -> DOC
      ```
      */
    better = width: curCols: left: right: if fits (width - curCols) left then left else right;

    /**
      Checks if a DOCument fits within a given width

      # Type
      ```
      fits :: int -> DOC -> bool
      ```
      */
    fits = width: doc:
      if  width < 0 then false
      else DOCIter doc
        /* null => */ true
        /* text => */ (string: rest: fits (width - builtins.stringLength string) rest)
        /* line => */ (indent: rest: true)
        /* union => */ (left: right: throw "fits called on union document");

    /**
      Pretty prints a document, ensuring that it fits within the given
      max width if it is possible.

      # Type
      ```
      pretty :: int -> doc -> DOC
      ```
      */
    pretty = cols: doc: layout (best cols 0 doc);

    types = {
      /**
        A simplified internal representation of a document, used in the latter stages of the
        pretty printing process. This is similar to the `doc` type, but each variant
        carries the "rest" of the document, instead of having an explicit concat variant,
        and line breaks carry their indentation level instead of having a nest variant.
        */
      DOC = lib.types.nullOr (lib.types.attrTag {
        text = lib.types.mkOption {
          type = lib.types.submodule {
            string = lib.types.mkOption {
              type = lib.types.str;
              default = "";
              description = "A section of text";
            };

            rest = lib.types.mkOption {
              type = pretty.types.DOC;
              default = null;
              description = "Rest of the document";
            };
          };
        };

        line = lib.types.mkOption {
          type = lib.types.submodule {
            indent = lib.types.mkOption {
              type = lib.types.int;
              default = 2;
              description = "Indentation level for nested lines";
            };
            rest = lib.types.mkOption {
              type = pretty.types.DOC;
              default = lib.types.null;
              description = "Rest of the document";
            };
          };

        };

        union = lib.types.mkOption {
          type = lib.types.submodule {
            left = lib.types.mkOption {
              type = pretty.types.DOC;
              default = null;
              description = "Left side of the union";
            };
            right = lib.types.mkOption {
              type = pretty.types.DOC;
              default = null;
              description = "Right side of the union";
            };
          };
        };
      });

      /**
        A user-facing representation of a document.

        Elements of this type should *only* be constructed using the functions
        exported from this module. Proper ordering of "union" variants
        is essential for the algorithm to work correctly.
        */
      doc = lib.types.nullOr (lib.types.attrTag {
        concat = lib.types.mkOption {
          type = lib.types.submodule {
            left = lib.types.mkOption {
              type = pretty.types.doc;
              default = null;
              description = "Left document to concatenate";
            };
            right = lib.types.mkOption {
              type = pretty.types.doc;
              default = null;
              description = "Right document to concatenate";
            };
          };
        };

        nest = lib.types.mkOption {
          type = lib.types.submodule {
            level = lib.types.mkOption {
              type = lib.types.int;
              default = 2;
              description = "Number of spaces to indent each line";
            };
            doc = lib.types.mkOption {
              type = pretty.types.doc;
              default = null;
              description = "Document to indent";
            };
          };
        };

        text = lib.types.mkOption {
          type = lib.types.submodule {
            string = lib.types.mkOption {
              type = lib.types.str;
              default = "";
              description = "A section of text";
            };
          };
        };

        line = lib.types.mkOption {
          type = lib.types.submodule {
            alternative = lib.types.mkOption {
              type = lib.types.str;
            };
          };

        };

        union = lib.types.mkOption {
          type = lib.types.submodule {
            left = lib.types.mkOption {
              type = pretty.types.doc;
              default = null;
              description = "Left side of the union";
            };
            right = lib.types.mkOption {
              type = pretty.types.doc;
              default = null;
              description = "Right side of the union";
            };
          };
        };
      });
    };
}; in {
  inherit (pretty) pretty concat sequence end text line nest group hardline lineWithAlt;
  inherit (pretty.types) doc;
}
