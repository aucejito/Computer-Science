def iguales(c1, c2):
    for i,j in zip(c1, c2):
        if i!=j:
            print(i)
            print(j)
            return False
    return True

if __name__ == "__main__":
    c1 = "LCCWCJBZSAFPTGXOUZHHFPXBKVFHJJIFZCZRAJKNYKPGARJSQCXRPGVMFLBVRNLCFXINRUUMZGRMLMLORFUXKCFCPVIZCRQWKLMUKJXBANABOLXVOSXMJJYHK"
    c2 = "LCCWCJBZSAFPTGXOUZHHFPXBKVFHJJIFZCZRAJKNYKPGARJSQCXRPGVMFLBVRNLCFXINRUUMZGRMLMLORFUXKCFCPVIZCRQWKLMUKJXBANABOLXVOSXMJJYHK"
    print(iguales(c1, c2))