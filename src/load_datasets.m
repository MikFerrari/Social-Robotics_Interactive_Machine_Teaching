nSamples_train = 20;
nSamples_test = 10;

numrows = 500;
numcols = 500;

% Cats Training Set
imagefiles_train_cat = dir('.\data\train\cat\*.jpg');      
nfiles = length(imagefiles_train_cat);
train_cat = cell(nfiles,1);
for i = 1:nfiles
   currentfilename = imagefiles_train_cat(i).name;
   currentimage = imread(currentfilename);
   currentimage = imresize(currentimage,[numrows numcols]);
   train_cat{i} = currentimage;
end

% Cats Test Set
imagefiles_test_cat = dir('.\data\test\cat\*.jpg');      
nfiles = length(imagefiles_test_cat);
test_cat = cell(nfiles,1);
label_cat = cell(nfiles,1);
for i = 1:nfiles
   currentfilename = imagefiles_test_cat(i).name;
   currentimage = imread(currentfilename);
   currentimage = imresize(currentimage,[numrows numcols]);
   test_cat{i} = currentimage;
   label_cat{i} = 'Cat';
end

% Dogs Training Set
imagefiles_train_dog = dir('.\data\train\dog\*.jpg');      
nfiles = length(imagefiles_train_dog);
train_dog = cell(nfiles,1);
for i = 1:nfiles
   currentfilename = strcat(imagefiles_train_dog(i).folder,'\',imagefiles_train_dog(i).name);
   currentimage = imread(currentfilename);
   currentimage = imresize(currentimage,[numrows numcols]);
   train_dog{i} = currentimage;
end

% Dogs Test Set
imagefiles_test_dog = dir('.\data\test\dog\*.jpg');      
nfiles = length(imagefiles_test_dog);
test_dog = cell(nfiles,1);
label_dog = cell(nfiles,1);
for i = 1:nfiles
   currentfilename = strcat(imagefiles_test_dog(i).folder,'\',imagefiles_test_dog(i).name);
   currentimage = imread(currentfilename);
   currentimage = imresize(currentimage,[numrows numcols]);
   test_dog{i} = currentimage;
   label_dog{i} = 'Dog';
end

% Create whole Training Set
train = vertcat(train_cat,train_dog);
idx = randperm(2*nSamples_train);
train = train(idx);

% Create whole Test Set
idx = randperm(2*nSamples_test);

test = vertcat(test_cat,test_dog);
test = test(idx);

label_test = vertcat(label_cat, label_dog);
label_test = label_test(idx);
