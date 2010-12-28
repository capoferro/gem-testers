require 'tinyatom'

def generate_feed(rubygem)
  feed = TinyAtom::Feed.new(
    app.rubygem_url(rubygem),
    "Gem Test Results for #{rubygem.name}",
    app.rubygem_feed_url(rubygem),
  )

  # get the last 25 results for this gem.
  results = TestResult.joins(:version).
              where(["versions.rubygem_id = ?", 3]).
              order("test_results.created_at DESC").
              take(25)

  results.each do |result|
    feed.add_entry(
      result.id,
      "#{result.result ? "PASS" : "FAIL"} Test Result ##{result.id} for gem #{rubygem.name} version #{result.version.number}",
      result.created_at,
      app.rubygem_version_test_result_url(result.rubygem.name, result.version, result)
    )
  end

  feed.make(:indent => 4)
end
