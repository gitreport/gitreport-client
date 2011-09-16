module GitAccount
  class Hook

    # creates a hook file if not exists and adds our hook line if it does not exist already
    def self.set!
      create_hook_file! unless hook_file_exists?
      set_hook!
    end

    private

    # creates a git hook file
    def self.create_hook_file!
      write_to_file doc
    end

    # writes given data to hook file
    def self.write_to_file data
      begin
        File.open(hook_file, 'w') {|f| f.write(data);f.close }
      rescue Exception => e
        puts "Error while writing hookfile #{hook_file}: #{e}"
      end
    end

    # returns the hook files content
    def self.file_content
      begin
        @@content ||= File.open(hook_file, 'r').read
      rescue Exception => e
        puts "Error while reading hookfile #{hook_file}: #{e}"
      end
    end

    # returns true if a git hook file already exists, false else
    def self.hook_file_exists?
      File.exists? hook_file
    end

    # set's our hook line into an existing hook file if it does not exist already
    def self.set_hook!
      set_line! unless line_exists?
    end

    # returns true if the hook file already has a hook line in
    def self.line_exists?
      if file_content.match(/bundle\sexec\scommit\s&/)
        return true
      end

      false
    end

    # sets our hook line
    def self.set_line!
      write_to_file(file_content + line)
    end

    # returns the hook files path
    def self.hook_file
      @@file ||= File.join('.', '.git', 'hooks', 'post-commit')
    end

    # returns the document header
    def self.doc
      "# This is a post-commit hook created by gitaccount (http://gitaccount.com)\n" +
        "#\n" +
        "# To remove it issue 'bundle exec unregister' in the projects main directory\n" +
        "# In case the gitaccount gem is not installed anymore, simply remove this hook file\n" +
        "#\n" +
        "# Be aware of other post commit hooks that my be mentioned here!\n"
    end

    # returns the line to activate gitaccount via post commit hook
    def self.line
      "\nbundle exec commit &\n"
    end

  end
end
