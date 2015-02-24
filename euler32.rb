$permutations = []

def generate(partial_perm)
  size = 9
  $permutations << partial_perm if partial_perm.length == size
  (1..size).to_a.each do |num|
    unless partial_perm.include?(num)
      next_perm = partial_perm.dup + [num]
      if !$permutations.include?(next_perm)
        generate(next_perm)
      end
    end
  end
end


def product?(nums)
  true
end
