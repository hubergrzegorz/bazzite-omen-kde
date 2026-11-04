import pathlib
p = pathlib.Path("recipe.yml")
content = p.read_text()
old_dnf = """  - type: dnf
    repos:
      files:
        - system/etc/yum.repos.d/darkly.repo
        - system/etc/yum.repos.d/brave.repo
        - system/etc/yum.repos.d/infinality-kwin.repo"""

link = "https://" + "brave-browser-rpm-release" + ".s3." + "brave.com" + "/brave-browser.repo"

new_dnf = f"""  - type: dnf
    repos:
      files:
        - {link}
      copr:
        - deltacopy/darkly
        - infinality/kwin-effects-better-blur-dx"""

if old_dnf in content:
    p.write_text(content.replace(old_dnf, new_dnf))
    print("Sukces! Zmodyfikowano recipe.yml")
else:
    print("Nie dopasowano starej struktury dnf w recipe.yml. Sprawdź zawartość.")
