# Mermaid

#markdown #mermaid #uml


參考文件: https://mermaid-js.github.io/mermaid/#/



```mermaid
flowchart LR
	id-->ss
	ss-->dd
	dd-->id
	id-->pp
	pp-->ss
	pp-->aa
	aa-->bb
	bb-->id
```

```mermaid
flowchart TD
	start[hajime]-->eddddnd[endless]
```

```mermaid
gitGraph:
commit
commit
commit
branch ss
checkout ss
commit
commit
checkout master
commit
merge ss

```

```mermaid
classDiagram
	class IExWorlder{
		+Career career
	}
	Cheater ..|> IExWorlder : Realization
	Hajime ..|> IExWorlder
	class Hajime{
		+List~AtelierSkill~ AtelierSkills 
	}
	class Cheater{
		+Bonus bonus
		+Gai()
	}
	
```

