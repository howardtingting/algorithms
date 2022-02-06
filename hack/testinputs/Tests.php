<?hh

trait TestStructures {
    public vec<num> $vecnums = vec[1,2,3,4,5,6,7,8,9];
    public vec<string> $vecstrings = vec["hello", "world", "i", "am", "here"];
    public vec<vec<num>> $vecvecnums = vec[vec[1,2,3], vec[4,5,6], vec[7,8,9]];

    public function construct_random_target_from<Tv>(vec<Tv> $arr, int $random_loop_count = 10): vec<Tv> {
        //put $arr in arrstack
        //$randomloopcount = number from 0 to len(arr)
        //loop:
            //randomnumber = number from 0 and len(arr)
            //$val = $arr[$randomnumber]
            //$resultstack.push($val)
        //return $resultstack
        $result_stack = vec<Tv>[];
        foreach($arr as $arr_values) {
            $randomnumber = random_int(0, count($arr));
            $result_stack[] = $arr_values;
        }
        return $result_stack;
    }

    public function print_vec<Tv>(vec<Tv> $arr): void {
        foreach($arr as $arr_value) {
            if ($arr_value is string) {
                echo $arr_value." ";
            } elseif ($arr_value is vec<_>){
                echo "printing vec of vec:\n";
                $this->print_vec($arr_value);
                echo "\n";
            }
        }
    }
}

final class Tests {
    use TestStructures;
    public function __construct() {}
}

<<__EntryPoint>>
function main(): void {
    $Test = new Tests();
    $target = $Test->construct_random_target_from($Test->vecnums);
    $Test->print_vec($target);
    print("\nexiting main program\n");
}