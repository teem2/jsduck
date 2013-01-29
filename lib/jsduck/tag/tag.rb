module JsDuck::Tag
  # Base class for all builtin tags.
  class Tag
    # Defines the name of the @tag.
    # The name itself must not contain the "@" sign.
    # For example: "cfg"
    attr_reader :pattern

    # Called by DocParser when the @tag is reached to do the parsing
    # from that point forward.  Gets passed an instance of DocScanner.
    #
    # Can return a hash or array of hashes representing the detected
    # @tag data.  Each returned hash must contain the :tagname key,
    # e.g.:
    #
    #     {:tagname => :protected, :foo => "blah"}
    #
    # All hashes with the same :tagname will later be combined
    # together and passed on to #process_doc method of this Tag class
    # that has @key field set to that tagname.
    #
    # The hash can also contain :doc => :multiline, in which case all
    # the documentation following this tag will get added to the :doc
    # field of the tag and will later be accessible in #process_doc
    # method.
    def parse_doc(p)
    end

    # Defines the symbol under which the tag data is stored in final
    # member/class hash.
    attr_reader :key

    # Gets called with the resulting class/member hash and array of
    # @tag data that was generated by #parse_doc. Also a hash with
    # position information {:filename, :linenr} is passed in.
    #
    # It can then add a new field to the class/member hash or
    # transform it in any other way desired.
    def process_doc(hash, docs, position)
    end

    # Defines that the tag defines a class member and specifies a name
    # for the member type.  For example :event.
    attr_reader :member_type

    # The text to display in member signature.  Must be a hash
    # defining the short and long versions of the signature text:
    #
    #     {:long => "something", :short => "SOM"}
    #
    # Additionally the hash can contain a :tooltip which is the text
    # to be shown when the signature bubble is hovered over in docs.
    attr_reader :signature

    # Defines the name of object property in Ext.define()
    # configuration which, when encountered, will cause the
    # #parse_ext_define method to be invoked.
    attr_reader :ext_define_pattern

    # The default value to use when Ext.define is encountered, but the
    # key in the config object itself is not found.
    # This must be a Hash defining the key and value.
    attr_reader :ext_define_default

    # Called by Ast class to parse a config in Ext.define().
    # @param {Hash} cls A simple Hash representing a class on which
    # various properties can be set.
    # @param {AstNode} ast Value of the config in Ext.define().
    def parse_ext_define(cls, ast)
    end

    # In the context of which members or classes invoke the #merge
    # method.  This can be either a single tagname like :class,
    # :method, :cfg or an array of these.
    #
    # Additionally a special :member symbol can be used to register a
    # merger for all the member types.  So to register a merger for
    # everyting you would set @merge_context = [:class, :member]
    attr_reader :merge_context

    # Merges documentation and code hashes into the result hash.
    def merge(hash, docs, code)
    end

    # The position for outputting the HTML for the tag in final
    # documentation.  For values, use the constants define below, or
    # specify your own numberic value.
    #
    # Must be defined together with #to_html method.  Additionally the
    # #format method can be defined to perform rendering of Markdown
    # before #to_html is called.
    attr_accessor :html_position

    POS_BEFORE_DOC = 1
    POS_DOC = 2
    POS_AFTER_DOC = 3
    POS_PARAMS = 4
    POS_RETURN = 5
    POS_THROWS = 6

    # Called before #to_html to allow rendering of Markdown content.
    # For this an instance of DocFormatter is passed in, on which one
    # can call the #format method to turn Markdown into HTML.
    def format(context, formatter)
    end

    # Implement #to_html to transform tag data to HTML to be included
    # into documentation.
    #
    # It gets passed the full class/member hash. It should return an
    # HTML string to inject into document.
    def to_html(context)
    end

    # Returns all descendants of JsDuck::Tag::Tag class.
    def self.descendants
      result = []
      ObjectSpace.each_object(::Class) do |cls|
        result << cls if cls < self
      end
      result
    end
  end
end
