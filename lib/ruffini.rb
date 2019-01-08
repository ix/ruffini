require 'zlib'

##
# Module containing the Markov chain generator class.
module Ruffini
  VERSION = '1.0.0'

  ##
  # This class provides a markov chain text generator.
  class Markov
      ##
      # Creates a new markov text generator with a given +depth+.
      #
      # If no +depth+ is provided, the constructor defaults to a depth of 2.
      #
      # If a +filename+ is provided, the constructor reads the dictionary from a file.
      def initialize(depth = 2, filename = nil)
          @DEPTH = depth
          if filename.nil?
              @store = {}
          else
              @store = Marshal.load(Zlib::Inflate.inflate(File.read(filename)))
          end
      end

      ##
      # Parses a given +string+ and adds its words to the markov dictionary.
      def parse!(string)
          words = string.split.map(&:downcase)
          for index in 0 .. (words.length - (@DEPTH + 1))
              if @store[ words[index..index+(@DEPTH - 1)] ].nil?
                  @store[ words[index..index+(@DEPTH - 1)] ] = [words[index+@DEPTH]]
              else
                  @store[ words[index..index+(@DEPTH - 1)] ].push words[index+@DEPTH]
              end
          end
          return @store
      end

      ##
      # Convenience method to parse an entire file by +filename+.
      def parse_file!(filename)
          self.parse!(File.read(filename))
      end

      ##
      # Generates +count+ words using the dictionary, optionally starting from the last
      # n words of +start+, if +start+ is provided (accepts Array or String).
      def generate(count, start = nil)
          output = []
          
          if !start.nil?
              if start.class == String
                  key = start.downcase.split.last(@DEPTH)
              else
                  key = start.last(@DEPTH)
              end
          else
              key = @store.keys.shuffle.first
          end

          key.map { |word| output.push word }

          count.times {
              if @store[key].nil?
              else
                  word = @store[key].shuffle.first
                  output.push word
                  key = key.last(@DEPTH - 1).push word
              end
          }

          output.join(" ")
      end

      ##
      # Serializes and compresses the markov dictionary to +filename+.
      # The file is stored as a zlib-compressed, marshalled Hash.
      def save!(filename)
          File.write(filename, Zlib::Deflate.deflate(Marshal.dump(@store)))
      end
  end
end
