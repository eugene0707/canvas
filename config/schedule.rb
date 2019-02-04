every 1.hours do
  rake 'tmp:waste:clear'
  rake 'tmp:waste:clear[public/system/xml_files/contents]'
end
