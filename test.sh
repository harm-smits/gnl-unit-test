#!/bin/bash

set -e

cd $(dirname $0)
gcc -Wall -Werror -Wextra main1.c get_next_line.c get_next_line_utils.c -o a.out -D BUFFER_SIZE=128 || (echo COMPILATION FAILED && exit 1)
echo ">>>>>>>>>>> Read main1.c"
./a.out < main1.c > yours || (echo EXECUTION FAILED && exit 1)
./test.out < main1.c > ours
diff yours ours || (echo FAILED && exit 1)
echo ">>>>>>>>>>> Read empty file"
rm -f lol
touch lol
./a.out < lol > yours
./test.out < lol > ours
diff yours ours || (echo FAILED && exit 1)
rm -f lol
echo ">>>>>>>>>>> Read big file"
for i in `seq 1 10000 100000`; do
    for j in `seq 1 10`; do
        base64 /dev/urandom | tr -d '/+' | fold -w $i | head -n $j > lol
        ./a.out < lol > yours || (echo EXECUTION FAILED && exit 1)
        ./test.out < lol > ours
        diff yours ours || (echo FAILED && exit 1)
    done
done
rm -f lol
echo ">>>>>>>>>>> Read big file 2"
echo > lol
for i in `seq 1 10`; do cat lol >> lol1; cat lol1 >> lol; done
./a.out < lol > yours || (echo EXECUTION FAILED && exit 1)
./test.out < lol > ours
diff yours ours || (echo FAILED && exit 1)
rm -f lol
rm -f lol1
echo ">>>>>>>>>>> Read big file 3"
echo a > lol
for i in `seq 1 10`; do cat lol >> lol1; cat lol1 >> lol; done
./a.out < lol > yours || (echo EXECUTION FAILED && exit 1)
./test.out < lol > ours
diff yours ours || (echo FAILED && exit 1)
rm -f lol
rm -f lol1
echo ">>>>>>>>>>> Sequential Read"
gcc -Wall -Werror -Wextra main2.c get_next_line.c get_next_line_utils.c -D BUFFER_SIZE=128 -o a.out
gcc -Wall -Werror -Wextra main2_generator.c -o gen.out
./gen.out > ours
./a.out > yours || (echo EXECUTION FAILED && exit 1)
diff yours ours  || (echo FAILED && exit 1)
rm -f yours ours
rm -f a.out gen.out