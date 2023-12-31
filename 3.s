.data
	#mat: .space 400008
	#act: .space 400008
	#aux: .space 400008
	v_vecini: .space 400008
	legaturi: .space 404
	arg4: .asciz "PROT_NONE"
	arg5: .asciz "MAP_SHARED"
	cerinta: .space 4
	sursa: .space 4
	destinatie: .space 4
	mat: .long 4
	act: .long 4
	aux: .long 4
	i: .space 4
	j: .space 4
	k: .space 4
	x: .space 4
	n: .space 4
	t: .space 4
	linie: .space 4
	coloana: .space 4
	fsf: .asciz "%d"
	fprintf: .asciz "%d "
	finprintf: .asciz "\n"
	fpf: .asciz "%d\n"
.text

matrix_mult:
	pushl %ebp
	movl %esp, %ebp
	subl $24, %esp

	movl %ebx, -24(%ebp)
	movl %esi, -20(%ebp)
	movl %edi, -16(%ebp)

	movl $0, -4(%ebp)
	movl $0, -8(%ebp)
	movl $0, -12(%ebp)

t_m_while1:
	movl -12(%ebp), %eax
	movl 20(%ebp), %ecx
	cmp %eax, %ecx
	je t_m_ex_while1
	movl $0, -8(%ebp)

	t_m_while2:
		movl -8(%ebp), %eax
		cmp %eax, %ecx
		je t_m_ex_while2

		movl -12(%ebp), %eax
		xorl %edx, %edx
		movl 20(%ebp), %ecx
		mul %ecx
		movl %eax, %ecx
		add -8(%ebp), %ecx
		movl 16(%ebp), %edx
		movl $0, (%edx, %ecx, 4)
		movl $0, -4(%ebp)

		t_m_while3:
			movl -4(%ebp), %eax
			movl 20(%ebp), %ecx
			cmp %eax, %ecx
			je t_m_ex_while3

			movl -12(%ebp), %eax
			movl 20(%ebp), %ecx
			xorl %edx, %edx
			mul %ecx
			movl -4(%ebp), %ecx
			add %eax, %ecx
			movl 8(%ebp), %eax
			movl (%eax, %ecx, 4), %esi
			
			movl -4(%ebp), %eax
			movl 20(%ebp), %ecx
			xorl %edx, %edx
			mul %ecx
			movl -8(%ebp), %ecx
			add %eax, %ecx
			movl 12(%ebp), %eax
			movl (%eax, %ecx, 4), %edi
			movl %esi, %eax
			xorl %edx, %edx
			mul %edi
			movl %eax, %esi

			movl -12(%ebp), %eax
			xorl %edx, %edx
			movl 20(%ebp), %ecx
			mul %ecx
			movl -8(%ebp), %ecx
			add %eax, %ecx
			movl 16(%ebp), %eax
			addl %esi, (%eax, %ecx, 4)

			addl $1, -4(%ebp)
			jmp t_m_while3

		t_m_ex_while3:
		addl $1, -8(%ebp)
		jmp t_m_while2

	t_m_ex_while2:
	addl $1, -12(%ebp)
	jmp t_m_while1

t_m_ex_while1:
	#popl %edi
	#popl %esi
	#popl %ebx

	#popl %edx
	#popl %edx
	#popl %edx

	#popl %edi
	#popl %esi
	#popl %ebx
	movl -24(%ebp), %ebx
	movl -20(%ebp), %esi
	movl -16(%ebp), %edi

	addl $24, %esp
	popl %ebp
	ret


.global main
main:

	pushl $cerinta
	pushl $fsf
	call scanf
	popl %edx
	popl %edx

	pushl $n
	pushl $fsf
	call scanf
	popl %edx
	popl %edx

	lea legaturi, %eax
	movl $0, %ecx
t_w1:
	cmp n, %ecx
	je t_ex_w1

	pusha
	pushl $x
	pushl $fsf
	call scanf
	popl %edx
	popl %edx
	popa

	movl x, %edx
	movl %edx, (%eax, %ecx, 4)
	add $1, %ecx
	jmp t_w1

t_ex_w1:
	movl $0, i
	movl $0, j
	movl $0, k
	jmp t_w2

t_i1_w2:
	addl $1, i
	jmp t_w2

t_w2:
	movl i, %eax
	cmp n, %eax
	je t_ex_w2

	lea legaturi, %ecx
	movl (%ecx, %eax, 4), %edx
	cmp $0, %edx
	je t_i1_w2

	pusha
	pushl $x
	pushl $fsf
	call scanf
	popl %edx
	popl %edx
	popa

	lea v_vecini, %eax
	movl k, %ebx
	movl x, %ecx
	movl %ecx, (%eax, %ebx, 4)
	addl $1, k
	addl $1, j
	
	lea legaturi, %eax
	movl i, %ebx
	movl (%eax, %ebx, 4), %ecx
	cmp j, %ecx
	jne t_w2
	movl $0, j
	addl $1, i
	jmp t_w2

t_ex_w2:

	movl $192, %eax
	#numarul de acces al functiei
	movl $0, %ebx
	#locul de start al alocarii memoriei va fi decis de OS
	movl $400008, %ecx
	#dimensiunea in bytes a vectorului matrice
	movl $3, %edx
	#definim PROT_WRITE care are valoarea 2 
	movl $34, %esi
	#definim MAP_SHARED ce are valoarea 4
	movl $-1, %edi
	#punem -1 pentru file descriptor fiindca nu lucram cu un fisier
	movl $0, %ebp
	#offsetul de la care vrem sa plecam in fisier, dar nu avem fisier deci e 0
	int $0x80
	addl $28, %esp
	movl %eax, mat

	movl $192, %eax
	#numarul de acces al functiei
	movl $0, %ebx
	#locul de start al alocarii memoriei va fi decis de OS
	movl $400008, %ecx
	#dimensiunea in bytes a vectorului matrice
	movl $3, %edx
	#definim PROT_WRITE care are valoarea 2 
	movl $34, %esi
	#definim MAP_SHARED ce are valoarea 4
	movl $-1, %edi
	#punem -1 pentru file descriptor fiindca nu lucram cu un fisier
	movl $0, %ebp
	#offsetul de la care vrem sa plecam in fisier, dar nu avem fisier deci e 0
	int $0x80
	addl $28, %esp
	movl %eax, act

	movl $0, linie
	movl $0, coloana
	movl $0, j
	movl $0, k

t_w3:
	movl linie, %eax
	cmp n, %eax
	je t_ex_w3
	movl $0, coloana
	movl $0, j
	t_w4:
		lea legaturi, %eax
		movl linie, %ebx
		movl (%eax, %ebx, 4), %ecx
		cmp j, %ecx
		je t_ex_w4
		lea v_vecini, %eax
		movl k, %ebx
		movl (%eax, %ebx, 4), %edx
		movl %edx, x
		t_w5:
			movl coloana, %eax
			cmp x, %eax
			je t_ex_w5

			movl linie, %eax
			xorl %edx, %edx
			movl n, %ecx
			mul %ecx
			movl coloana, %ecx
			addl %eax, %ecx

			movl mat, %eax
			movl $0, (%eax, %ecx, 4)
			movl act, %eax
			movl $0, (%eax, %ecx, 4)

			addl $1, coloana
			jmp t_w5

		t_ex_w5:

		movl linie, %eax
		xorl %edx, %edx
		movl n, %ecx
		mul %ecx
		movl coloana, %ecx
		addl %eax, %ecx

		movl mat, %eax
		movl $1, (%eax, %ecx, 4)
		movl act, %eax
		movl $1, (%eax, %ecx, 4)

		addl $1, coloana
		addl $1, k
		addl $1, j
		jmp t_w4

	t_ex_w4:

	t_w6:
		movl coloana, %eax
		cmp n, %eax
		je t_ex_w6

		movl linie, %eax
		xorl %edx, %edx
		movl n, %ecx
		mul %ecx
		movl coloana, %ecx
		addl %eax, %ecx

		movl mat, %eax
		movl $0, (%eax, %ecx, 4)
		movl act, %eax
		movl $0, (%eax, %ecx, 4)

		addl $1, coloana
		jmp t_w6

	t_ex_w6:

	addl $1, linie
	jmp t_w3

t_ex_w3:
	pushl $k
	pushl $fsf
	call scanf
	popl %edx
	popl %edx

	pushl $sursa
	pushl $fsf
	call scanf
	popl %edx
	popl %edx

	pushl $destinatie
	pushl $fsf
	call scanf
	popl %edx
	popl %edx

	movl $192, %eax
	#numarul de acces al functiei
	movl $0, %ebx
	#locul de start al alocarii memoriei va fi decis de OS
	movl $400008, %ecx
	#dimensiunea in bytes a vectorului matrice
	movl $3, %edx
	#definim protectia de citire si de scriere care fac 3 dupa operatia OR
	movl $34, %esi
	#definim memoria ca fiind vizibila doar pt procesul actual si declarata cu 0 care face 34 dupa operatia de OR
	movl $-1, %edi
	#punem -1 pentru file descriptor fiindca nu lucram cu un fisier
	movl $0, %ebp
	#offsetul de la care vrem sa plecam in fisier care e 0
	int $0x80
	addl $28, %esp
	movl %eax, aux

	movl $1, t

t_w8:
	movl t, %eax
	cmp k, %eax
	je t_ex_w8

	pushl n
	pushl aux
	pushl mat
	pushl act
	call matrix_mult
	popl %edx
	popl %edx
	popl %edx
	popl %edx

	movl $0, linie
	movl $0, coloana
	t_w9:
		movl linie, %eax
		cmp n, %eax
		je t_ex_w9

		movl $0, coloana

		t_w10:
			movl coloana, %eax
			cmp n, %eax
			je t_ex_w10

			movl linie, %eax
			xorl %edx, %edx
			movl n, %ecx
			mul %ecx
			movl coloana, %ecx
			addl %eax, %ecx
			movl aux, %eax
			movl (%eax, %ecx, 4), %ebx
			movl act, %eax
			movl %ebx, (%eax, %ecx, 4)

			addl $1, coloana
			jmp t_w10
		t_ex_w10:
		
		addl $1, linie
		jmp t_w9

	t_ex_w9:
	addl $1, t
	jmp t_w8

t_ex_w8:
	movl sursa, %eax
	xorl %edx, %edx
	movl n, %ecx
	mul %ecx
	movl destinatie, %ecx
	addl %eax, %ecx
	movl act, %eax
	movl (%eax, %ecx, 4), %ebx

	pusha
	pushl %ebx
	pushl $fpf
	call printf
	popl %edx
	popl %edx
	popa
	jmp t_exit

t_exit:
	movl $1, %eax
	xorl %ebx, %ebx
	int $0x80
