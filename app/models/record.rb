require 'tokyocabinet'
include TokyoCabinet

class Record

  class << self
  
    attr_accessor :hdb
  
    def all
      perform_operation do
        records = {}
        @hdb.iterinit
        while key = @hdb.iternext
         records[key] = @hdb.get(key)
        end
        records 
      end
    end
  
    def create(key, value)
      perform_operation do
        @hdb.put(key, value)
      end
    end
  
    def perform_operation
      return if !block_given?
    
      @hdb = HDB.new
      path = File.join(Rails.root, "db/development.tch")
      @hdb.open(path, HDB::OWRITER | HDB::OCREAT)
    
      result = yield
      result == false ? report_tokyo_cabinet_error : result
    ensure
      @hdb.close
    end

    def report_tokyo_cabinet_error
      ecode = @hdb.ecode
      message = @hdb.errmsg(ecode)
      raise "Error: #{message}"
    end
    
  end
  
end