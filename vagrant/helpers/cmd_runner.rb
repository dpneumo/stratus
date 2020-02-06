class CmdRunner
  def self.run(cmd)
    return if cmd.nil?
    return unless [ String, Array ].include? cmd.class
    return if cmd.empty?
    self.new.evaluate(cmd)
  end

  def initialize( vbdir: 'C:\Program Files\Oracle\VirtualBox',
                  iorunner: IO )
    @vbdir = vbdir
    @iorunner = iorunner
  end

  def evaluate(cmd)
    result = @iorunner.popen(cmd, err: %i[child out], chdir: @vbdir) do |io|
      io.readlines
    end
    raise "Error running: '#{cmd}'" unless $?.exitstatus.zero?
    result
  end
end

