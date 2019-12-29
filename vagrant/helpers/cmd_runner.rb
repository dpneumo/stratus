class CmdRunner
  def initialize( cmd: ,
                  vbdir: 'C:\Program Files\Oracle\VirtualBox' )
    @cmd, @vbdir = cmd, vbdir
  end

  def runcmd
    out = IO.popen(@cmd, err: %i[child out], chdir: @vbdir) do |io|
      io.readlines
    end
    raise "Error running command #{@cmd}" unless $?.exitstatus.zero?
    out
  end
end

