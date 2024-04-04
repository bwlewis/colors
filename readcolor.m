function ans = readcolor(url)
  data = urlread(url);
  % Write the data to a temporary file
  temp_file = 'temp.csv';
  fid = fopen(temp_file, 'w');
  fwrite(fid, data);
  fclose(fid);
  % Read the CSV data from the temporary file
  ans = csvread(temp_file);
  % Delete the temporary file
  delete(temp_file);
end
