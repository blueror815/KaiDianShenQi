module MyTestHelper
  module FloatHelper
    def approximate_eql(a, b, eps)
      dif = (a.to_f - b.to_f).abs
      if dif <= eps
        true
      else
        false
      end
    end
  end
  module DebugHelper
    def puts_json(my_json)
      puts JSON.pretty_generate(my_json)
    end

  end
end