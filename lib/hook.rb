require "digest/sha1"

module GitAccount
  class Hook

    # creates a hook file if not exists and adds our hook line if it does not exist already
    def self.set!
      create_hook_file! unless hook_file_exists?
      set_hook!
    end

    def self.remove!
      remove_hook! if hook_file_exists?
    end

    private

    # creates a git hook file
    def self.create_hook_file!
      write_to_file doc
    end

    # writes given data to hook file
    def self.write_to_file data
      begin
        File.open(hook_file, 'w') {|f| f.write(data);f.chmod(0755);f.close }
      rescue Exception => e
        puts "Error while writing hookfile #{hook_file}: #{e}"
        return false
      end

      true
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
      puts "Successfully registered post-commit hook." if (set_line! unless line_exists?)
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
      "#!/bin/sh\n" +
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

    # removes the hook
    def self.remove_hook!
      (remove_hook_file!; return) if hook_file_unchanged?
      remove_line! if line_exists?
    end

    # removes the hook file
    def self.remove_hook_file!
      begin
        File.unlink(hook_file)
        puts "Successfully removed git account post-commit hook (file).\n"
      rescue Exception => e
        puts "Error while removing hookfile #{hook_file}: #{e}"
      end
    end

    # returns true if the hook file is ours and was not changed
    def self.hook_file_unchanged?
      Digest::SHA1.hexdigest(file_content) == "c4285736f3ed53e82755dd23faef3f213e79cc5f"
    end

    # removes our hook line from hook file
    def self.remove_line!
      puts "Successfully removed git account post-commit hook.\n" if write_to_file(clean_up(file_content))
    end

    # removes our hook line from given content
    def self.clean_up content
      content.gsub(/\nbundle\sexec\scommit\s&\n/,'')
    end

  end
end
