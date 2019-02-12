# Copyright, 2019, by Samuel G. D. Williams. <http://www.codeotaku.com>
# 
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
# 
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
# 
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.

require 'build/environment'
require 'build/environment/system'

require_relative 'rule'

RSpec.describe Build::Environment do
	it "can execute update functions" do
		platform = Build::Environment.new do
			libraries []
			
			root "/usr"
			bin ->{File.join(root, "bin")}
			compiler ->{File.join(bin, "clang")}
			
			update do
				append libraries "m"
			end
		end
		
		task = Build::Environment.new(platform) do
			update do
				library_path = File.join(parent.checksum, "Time.a")
				
				append libraries library_path
			end
		end
		
		environment = task.flatten do |environment|
			environment.update!
		end
		
		expect(environment[:libraries].count).to be == 2
	end
end