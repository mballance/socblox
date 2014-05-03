
class c1 {
	public: int			i1;

	public:

		c1() {
			i1 = 25;
		}

};

static c1		c1_inst;
static c1		c2_inst;
static c1		c3_inst;
static c1		c4_inst;

int main(int argc, char **argv) {
	c1_inst.i1++;
}
