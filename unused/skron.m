function output = skron(A, B)
    m = size(A, 1);
    n = size(A, 2);
    Qm = vec2svecMat(m);
    Qn = vec2svecMat(n);
    output = Qm * (kron(A, B) + kron(B, A)) * Qn.' / 2;
end