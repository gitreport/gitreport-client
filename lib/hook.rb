require "digest/sha1"

module GitReport
  class Hook

    # creates a hook file if not exists and adds our hook line if it does not exist already
    def self.set!
      create_hook_file! unless (file_exists? hook_file)
      set_hook!
    end

    def self.remove!
      remove_hook! if (file_exists? hook_file)
    end

    private

    # creates a git hook file
    def self.create_hook_file!
      write_to_file hook_file, doc
    end

    # creates the custom hook if it does not exist already
    def self.create_custom_hook!
      write_to_file(custom_hook_file, custom_hook_doc) unless file_exists? custom_hook_file
    end

    # set's our hook line into an existing hook file if it does not exist already
    # create the custom hook file as well
    def self.set_hook!
      set_line! unless line_exists?
      create_custom_hook!
      puts "Successfully registered post-commit hook."
    rescue
      puts "Error during setting the hook, gitreport will not work as expected!"
    end

    # writes given data to hook file
    def self.write_to_file file, data
      begin
        File.open(file, 'w') {|f| f.write(data);f.chmod(0755);f.close }
      rescue Exception => e
        puts "Error while writing hookfile #{file}: #{e}"
        return false
      end

      true
    end

    # returns the hook files content
    def self.file_content
      begin
        File.open(hook_file, 'r').read
      rescue Exception => e
        puts "Error while reading hookfile #{hook_file}: #{e}"
      end
    end

    # returns true if a git hook file already exists, false else
    def self.file_exists? file
      File.exists? file
    end

    # returns true if the hook file already has a hook line in
    def self.line_exists?
      if file_content.match(/\nnohup\s\.git\/hooks\/gitreport-post-commit\s>\s\/dev\/null\s2>\s\/dev\/null\s<\s\/dev\/null\s&\n/)
        return true
      end

      false
    end

    # sets our hook line
    def self.set_line!
      write_to_file hook_file, (file_content + line)
    end

    # returns the hook files path
    def self.hook_file
      @@file ||= GitReport.project.path + "/.git/hooks/post-commit"
    end

    # returns the custom hook files path
    def self.custom_hook_file
      @@custom_hook_file ||= GitReport.project.path + "/.git/hooks/gitreport-post-commit"
    end

    # returns the document header
    def self.doc
      "#!/bin/sh\n" +
        "# This is a post-commit hook created by gitreport (http://gitreport.com)\n" +
        "#\n" +
        "# To remove it issue 'bundle exec deactivate' in the projects main directory\n" +
        "# In case the gitreport gem is not installed anymore, simply remove this hook file\n" +
        "#\n" +
        "# Be aware of other post commit hooks that my be mentioned here!\n"
    end

    # returns the line to activate gitreport via post commit hook
    def self.line
      "\nnohup .git/hooks/gitreport-post-commit > /dev/null 2> /dev/null < /dev/null &\n"
    end

    # returns the custom hook for gitreport
    def self.custom_hook_doc
      File.read(File.dirname(__FILE__) + "/../templates/gitreport-post-commit.bash")
    end

    # removes the hook
    def self.remove_hook!
      begin
        remove_file!(custom_hook_file) if file_exists? custom_hook_file
        if hook_file_unchanged?
          remove_file! hook_file
        else
          remove_line! if line_exists?
        end
        puts "Successfully removed gitreport post-commit hook files.\n"
      rescue Exception => e
        puts "Error while removing hookfiles: #{e}"
      end
    end

    # removes the the given hook file
    def self.remove_file! file
      File.unlink(file)
    end

    # returns true if the hook file is ours and was not changed
    def self.hook_file_unchanged?
      Digest::SHA1.hexdigest(file_content) == "004c9e7c9124ead7ed347fac7996bd92b6e4e3b9"
    end

    # removes our hook line from hook file
    def self.remove_line!
      puts "Successfully removed gitreport post-commit hook.\n" if write_to_file(hook_file, (clean_up(file_content)))
    end

    # removes our hook line from given content
    def self.clean_up content
      content.gsub(/\nnohup\s\.git\/hooks\/gitreport-post-commit\s>\s\/dev\/null\s2>\s\/dev\/null\s<\s\/dev\/null\s&\n/,'')
    end

  end
end
