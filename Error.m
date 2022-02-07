function [poe] = Error(A,p_fg,p_bg)
    cheetah_mask = imread('cheetah_mask.bmp');
    cheetah_mask = cheetah_mask == 255;

    cheetah_mask_one = find(cheetah_mask);
    cheetah_mask_zero = find(~cheetah_mask);

    num_incorrect_zero = sum(A(cheetah_mask_zero) == 1);
    num_incorrect_one = sum(A(cheetah_mask_one) == 0);

    poe = (num_incorrect_zero*p_bg)/sum(sum(cheetah_mask == 0)) +...
        (num_incorrect_one*p_fg)/sum(sum(cheetah_mask == 1));
end