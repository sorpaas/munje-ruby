class Lisp
  def initialize()
    @relations = {
      :eq => lambda { |(l,r)|
        ctx = @env

        if ctx.has_key? l and ctx.has_key? r
          if l != r
            raise "Cannot resolve variables."
          end
          return
        end
        if ctx.has_key? l and not ctx.has_key? r
          ctx[r] = ctx[l]
          return
        end
        if not ctx.has_key? l and ctx.has_key? r
          ctx[l] = ctx[r]
          return
        end
        if not ctx.has_key? l and not ctx.has_key? r
          raise "Not implemented."
        end
      }
    }

    @env = {}
  end

  def claim sexpr
    @relations[sexpr[0]].call(sexpr.drop(0))
  end

  def env
    @env
  end

  def relations
    @relations
  end
end
