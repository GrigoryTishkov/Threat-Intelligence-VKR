-- Блоки-предупреждения в стиле GitHub (> [!NOTE], > [!TIP] ...) превращаются в callout Quarto.
-- Так README одинаково заметно выглядит и на GitHub, и на сайте.
local kinds = { NOTE = 'note', TIP = 'tip', IMPORTANT = 'important', WARNING = 'warning', CAUTION = 'caution' }

function BlockQuote(el)
  local first = el.content[1]
  if not first or (first.t ~= 'Para' and first.t ~= 'Plain') or #first.content == 0 then return nil end
  local kind = pandoc.utils.stringify(first.content[1]):match('^%[!(%u+)%]$')
  if not kind or not kinds[kind] then return nil end
  table.remove(first.content, 1)
  while #first.content > 0 and (first.content[1].t == 'SoftBreak' or first.content[1].t == 'Space'
                                or first.content[1].t == 'LineBreak') do
    table.remove(first.content, 1)
  end
  if #first.content == 0 then table.remove(el.content, 1) end
  return quarto.Callout({ type = kinds[kind], content = el.content, appearance = 'simple' })
end
