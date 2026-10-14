export function filterTools(catalog, query, category = 'all') {
  const terms = query.trim().toLocaleLowerCase().split(/\s+/).filter(Boolean)
  return catalog.tools.filter(tool => {
    if (category !== 'all' && tool.category !== category) return false
    const text = [tool.name, tool.displayName, tool.vendor, tool.description,
      catalog.categories[tool.category]?.name, ...tool.features].join(' ').toLocaleLowerCase()
    return terms.every(term => text.includes(term))
  })
}

export function commandFor(tool) {
  return `irm ${tool.url.replace(/\.txt$/, '')} | iex`
}
