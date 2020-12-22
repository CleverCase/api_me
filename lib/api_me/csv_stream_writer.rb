require 'csv'
# frozen_string_literal: true

module ApiMe
  class CsvStreamWriter
    # @!attribute [r] stream
    #   @return [IO]
    attr_reader :stream

    # Provides a similar interface to CSV.generate but compatible with an IO stream
    # @example
    #   CsvStreamWriter.generate(stream) do |csv|
    #     csv << ['foo', 'bar']
    #   end
    #
    # @param [IO]
    # @yield [CsvStreamWriter] csv
    def self.generate(stream)
      yield new(stream)
    end

    # @param [IO]
    def initialize(stream)
      @stream = stream
    end

    # @param [Array<String>]
    def <<(row)
      stream.write CSV.generate_line(row)
    end
  end
end
