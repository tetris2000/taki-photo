
[1mFrom:[0m /home/ec2-user/environment/taki-photo/app/models/post.rb @ line 27 Post#save_exif:

    [1;34m19[0m: [32mdef[0m [1;34msave_exif[0m
    [1;34m20[0m:   require [31m[1;31m"[0m[31mexifr/jpeg[1;31m"[0m[31m[0m
    [1;34m21[0m:   [1;36mself[0m.shutter_speed = [1;34;4mEXIFR[0m::[1;34;4mJPEG[0m.new([1;36mself[0m.photo.file.file).exposure_time.to_f
    [1;34m22[0m:   [1;36mself[0m.f_number = [1;34;4mEXIFR[0m::[1;34;4mJPEG[0m.new([1;36mself[0m.photo.file.file).f_number.to_f
    [1;34m23[0m:   [1;36mself[0m.iso = [1;34;4mEXIFR[0m::[1;34;4mJPEG[0m.new([1;36mself[0m.photo.file.file).iso_speed_ratings.to_i
    [1;34m24[0m:   [1;36mself[0m.focal_length = [1;34;4mEXIFR[0m::[1;34;4mJPEG[0m.new([1;36mself[0m.photo.file.file).focal_length.to_f
    [1;34m25[0m:   [1;36mself[0m.camera = [1;34;4mEXIFR[0m::[1;34;4mJPEG[0m.new([1;36mself[0m.photo.file.file).model
    [1;34m26[0m:   [1;36mself[0m.taken_at = [1;34;4mEXIFR[0m::[1;34;4mJPEG[0m.new([1;36mself[0m.photo.file.file).date_time
 => [1;34m27[0m:   binding.pry
    [1;34m28[0m:   [32munless[0m [1;36mself[0m.taken_at.blank?
    [1;34m29[0m:     [1;36mself[0m.taken_at_year = [1;34;4mEXIFR[0m::[1;34;4mJPEG[0m.new([1;36mself[0m.photo.file.file).date_time.strftime([31m[1;31m"[0m[31m%Y[1;31m"[0m[31m[0m).to_i
    [1;34m30[0m:     [1;36mself[0m.taken_at_month = [1;34;4mEXIFR[0m::[1;34;4mJPEG[0m.new([1;36mself[0m.photo.file.file).date_time.strftime([31m[1;31m"[0m[31m%m[1;31m"[0m[31m[0m).to_i
    [1;34m31[0m:   [32mend[0m
    [1;34m32[0m: [32mend[0m

