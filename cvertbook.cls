% 版本设定
\NeedsTeXFormat{LaTeX2e}[1995/12/01]
\ProvidesClass{cvertbook}[2021/03/08 v0.0 Standard Chinese vertical document class] % 中文竖排书模板
\LoadClassWithOptions{book}

% 引用宏包
\RequirePackage[AutoFallBack]{xeCJK}
\RequirePackage{ruby}
\RequirePackage[landscape, includeheadfoot]{geometry} 
\RequirePackage{zhnumber}
\RequirePackage{atbegshi}
\RequirePackage{fancyhdr}
\RequirePackage{longtable}


% 边框使用的属性
\newlength{\myleft}
\newlength{\myright}
\newlength{\mytop}
\newlength{\mybottom}
\setlength{\myleft}{1.6cm}
\setlength{\myright}{1.6cm}
\setlength{\mytop}{1.16cm}
\addtolength{\mytop}{-0.3em}
\setlength{\mybottom}{1.16cm}
\addtolength{\mybottom}{0.27em}

\setlength{\topmargin}{0pt}
\setlength{\headheight}{1.7\baselineskip}
\setlength{\headsep}{0.3\baselineskip}
\setlength{\footskip}{2\baselineskip}

\geometry{
  left=\myleft,
  right=\myright,
  top=\mytop,
  bottom=\mybottom
}
\setlength{\parskip}{0pt}
\setlength{\parindent}{0em}

% 设置字间距
\renewcommand{\CJKglue}{\hskip 2pt plus 0.1\baselineskip}

% 单双页偏移
\newlength{\vertbookoffset}
\setlength{\vertbookoffset}{1cm}
% 设置竖排的装订线距离
\let\@@outputpage\@outputpage
\def\@outputpage{\expandafter\@oddgeometryeven\@@outputpage}
\def\@oddgeometryeven{%
  \ifodd\thepage
    \setlength{\voffset}{\vertbookoffset}
  \else
    \setlength{\voffset}{-\vertbookoffset}
\fi}


% -- 基础的直排效果
\defaultCJKfontfeatures{RawFeature={vertical:+vert:+vhal}}
% 将纸张旋转90度
\AtBeginShipout{%
  \global\setbox\AtBeginShipoutBox\vbox{%
    \special{pdf: put @thispage <</Rotate 90>>}%
    \box\AtBeginShipoutBox
  }%
}%


% 调整英文基线与句读
\xeCJKDeclarePunctStyle{judou}
{enabled-hanging = true}

\punctstyle{plain}

\newif\if@judou
\@judoufalse
\newcommand\judou{\@judoutrue}
\newif\if@nopunct
\@nopunctfalse
\newcommand\nopunct{\@nopuncttrue}

\newcommand*\CJKmovesymbol[1]{\raise.25em\hbox{#1}}
\newcommand*\CJKmovepunctsymbol[1]{\raise.6em\hb@xt@\z@{\hss#1}}
\newcommand*\CJKnopunctsymbol[1]{\setbox0=\hb@xt@\z@{\hss#1}\null}  %也不知道為什麼總之這樣可以把標點都消滅
\newcommand*\CJKmove{
  \let\CJKsymbol\CJKmovesymbol
  \if@nopunct
    \let\CJKpunctsymbol\CJKnopunctsymbol
  \else
    \if@judou
      \xeCJKsetwidth{。，、.．}{\z@}
      \xeCJKsetwidth*{。，、.．}{\z@}
      \punctstyle{quanjiao}
      \let\CJKpunctsymbol\CJKmovepunctsymbol
    \else
      \let\CJKpunctsymbol\CJKsymbol
    \fi
  \fi
}

\AtBeginDocument{\CJKmove \sloppy}



% -- 中文化编号
\newif\if@inmain
\@inmainfalse
\newcommand\inmain{\@inmaintrue}
\setcounter{tocdepth}{1}
\setcounter{secnumdepth}{1}   %设置深度到0即可
\renewcommand{\thepart}{\zhnum{part}}
\renewcommand{\thechapter}{\zhnum{chapter}}
\renewcommand{\thesection}{\zhnum{section}}
\renewcommand{\thesubsection}{\zhnum{subsection}}
\newcommand\zhpage{\zhdigits*{\thepage}}
\let\sectionmark\@gobble      %取消section的mark

% -- 页眉页脚设置
\pagestyle{fancy}
\fancyhf{}%清空页眉页脚
\fancyhead[RE]{\zhpage}% 偶数页右页眉
\fancyhead[LE]{\leftmark}% 偶数页左页眉
\fancyfoot[RO]{\zhpage}% 奇数页右页脚
\fancyfoot[LO]{\rightmark}% 奇数页左页脚
\fancypagestyle{plain}{%重新定义plain样式，在章的首页使用plain样式
\fancyhf{}
\renewcommand\headrulewidth{0pt}
\renewcommand\footrulewidth{0pt}
}

%\renewcommand\title#1{
%  \renewcommand\userbookname{#1}
%}

% 添加书、部、章、节名
\newcommand\userbookname{\@title}%书名
\newcommand\userpartname{}%{部名}
\newcommand\userchaptername{}%{章名}
\newcommand\usersectionname{}%{节名}

\def\headrule{{
  \if@fancyplain
    \let\headrulewidth\plainheadrulewidth
  \fi%
  \ifodd\thepage\relax
  \else%
    \vskip 0.3em
    \hrule\@height 0.5pt \@width\headwidth
  \fi
}}

\def\footrule{{
  \if@fancyplain
    \let\footrulewidth\plainfootrulewidth
  \fi%
  \ifodd\thepage
    \hrule\@height 0.5pt \@width\headwidth
    \vskip -0.2em
  \fi
}}

% 重写所有片段标题
% 重写部标题部分
\renewcommand\part{%
  \if@openright \cleardoublepage % 命令清空浮动体队列，并在奇数页上开始新的一页 根据效果看，应当是默认或是启用了openright参数
  \else \clearpage % 命令清空浮动体队列，并开始新的一页，在双栏排版中能够另起一页
  \fi
  \thispagestyle{empty}%
  \if@twocolumn
    \onecolumn
    \@tempswatrue
  \else
    \@tempswafalse
  \fi
  \null\vfill
  \secdef\@part\@spart
}

\def\@part[#1]#2{%
  \ifnum \c@secnumdepth >-2\relax
    \refstepcounter{part}%
    \addcontentsline{toc}{part}{#1}%
  \else
    \addcontentsline{toc}{part}{#1}%
  \fi
  \renewcommand\userpartname{#1}
  \renewcommand\userchaptername{}%{章名}
  \renewcommand\usersectionname{}%{节名}
  \updatemark
  %\markboth{\MakeUppercase #1}{\MakeUppercase #1}%
  {
  \vfill
  \interlinepenalty \@M
  \normalfont
  \Huge \hspace{2em} \bfseries{#1} \vskip 4em
  \@endpart
  }
}

\def\@spart#1{%
  {
  \vfill
  \interlinepenalty \@M
  \normalfont
  \Huge #1\par
  \@endpart
  }
}

\def\@endpart{
  \newpage
  \if@tempswa \twocolumn \fi
}

% 新命令，用于标记子部，例如史记中的本纪，在正文中没有什么效果，只是会标记页眉页脚并且在目录中添加一行
\newcommand\zibu[2][]{%
  \clearpage
  %\markboth{\MakeUppercase #1#2}{\MakeUppercase #1#2}%
  %\markright{\MakeUppercase #1}%\chaptermark{#1}% 
  %\markleft{\MakeUppercase #1}%\chaptermark{#1}%
  %\addcontentsline{toc}{part}{\hspace{1em}#2}%
}

% 新命令，用于更新页眉页脚 格式为[partname][chaptername]
\newcommand\updatemark{
  %\clearpage
  %\markboth{\MakeUppercase \userpartname\hspace{1em}\userchaptername}{\MakeUppercase \userpartname\hspace{1em}\userchaptername}
  \markboth{\MakeUppercase \userbookname\hspace{1em}\userpartname}{\MakeUppercase \userpartname\hspace{1em}\userchaptername\hspace{1em}\usersectionname}
  %\markright{\MakeUppercase \usersectionname}
  %\markright{\MakeUppercase \userpartname\hspace{1em}\userchaptername\hspace{1em}\usersectionname}
}

% 重写章标题部分
\renewcommand\chapter{
  \if@inmain \newpage%\clearpage 命令开始新的一页，在双栏排版中起到另起一栏的作用
  \else \clearpage % 命令清空浮动体队列，并开始新的一页，在双栏排版中能够另起一页
  \fi
  \global\@topnum\z@
  \@afterindentfalse
  \secdef\@chapter\@schapter
}

\def\@chapter[#1]#2{
  \ifnum \c@secnumdepth >\m@ne
    \if@mainmatter
      \refstepcounter{chapter}%
      \typeout{\@chapapp\space\thechapter.}%
      \addcontentsline{toc}{chapter}{\hspace{2em}#1}%
    \else
      \addcontentsline{toc}{chapter}{\hspace{2em}#1}%
    \fi
  \else
    \addcontentsline{toc}{chapter}{\hspace{2em}#1}%
  \fi
  \renewcommand\userchaptername{#1}
  \renewcommand\usersectionname{}%{节名}
  \updatemark
  %\markright{\MakeUppercase \userchaptername}%\chaptermark{#1}%
  \addtocontents{lof}{\protect\addvspace{10\p@}}%
  \addtocontents{lot}{\protect\addvspace{10\p@}}%
  \@makechapterhead{#1}%  \@afterheading %无星号版本允许首段缩进
}

\def\@makechapterhead#1{%
  {
  %\vspace*{\baselineskip}%
  \vspace*{0.4em}%
  \parindent \z@ \raggedright \normalfont
  \interlinepenalty\@M
  %\normalsize #1\par\nobreak
  \LARGE #1\par\nobreak
  \vskip \baselineskip
  }
}

\def\@schapter#1{
  \@makeschapterhead{#1}% 
  \@afterheading
}

\def\@makeschapterhead#1{%
  {
  \vspace*{0.0em}%
  \parindent \z@ \raggedright \normalfont
  \interlinepenalty\@M
  \normalsize #1\par\nobreak
  \vskip \baselineskip
  }
}

% 定义节、小节、段、小段
\renewcommand\section{
  %\@startsection{section}{1}{\z@}%
  %{-\baselineskip}%
  %{\baselineskip}%
  %{\normalfont\normalsize}
  \global\@topnum\z@
  \@afterindentfalse
  \secdef\@section\@ssection
}

\def\@section[#1]#2{
  \ifnum \c@secnumdepth >\m@ne
    \if@mainmatter
      \refstepcounter{section}
      \typeout{\@chapapp\space\thesection.}
      \addcontentsline{toc}{section}{\hspace{4em}#1}
    \else
      \addcontentsline{toc}{section}{\hspace{4em}#1}
    \fi
  \else
    \addcontentsline{toc}{section}{\hspace{4em}#1}
  \fi
  \renewcommand\usersectionname{#1}
  \updatemark
  %\markright{\MakeUppercase \usersectionname}
  \addtocontents{lof}{\protect\addvspace{10\p@}}
  \addtocontents{lot}{\protect\addvspace{10\p@}}
  \@makesectionhead{#1}
}

\def\@makesectionhead#1{
  {
    %\vspace*{0.35em}
    \vskip \baselineskip
    \parindent \z@ \raggedright \normalfont
    \interlinepenalty\@M
    %\normalsize \hspace{1em}#1\par\nobreak
    \Large \hspace{1em}#1\par\nobreak
    \vskip \baselineskip
  }
}

\def\@ssection#1{
  \@makessectionhead{#1}
  \@afterheading
}

\def\@makessectionhead#1{
  {
    \vspace*{0.0em}
    \parindent \z@ \raggedright \normalfont
    \interlinepenalty\@M
    \normalsize #1\par\nobreak
    \vskip \baselineskip
  }
}

\renewcommand\subsection{
  \@startsection{subsection}{2}{\z@}%
  {\baselineskip}%
  {\z@}%
  {\normalfont\normalsize}}

\renewcommand\subsubsection{
  \@startsection{subsubsection}{3}{\z@}%
  {0pt}%
  {-1em}%
  {\normalfont\normalsize}}

\renewcommand\paragraph{
  \@startsection{paragraph}{4}{\z@}%
  {0pt}%
  {-1em}%
  {\normalfont\normalsize}}

\renewcommand\subparagraph{
  \@startsection{subparagraph}{5}{\parindent}%
  {0pt}%
  {-1em}%
  {\normalfont\normalsize}}



% -- 重新定义目录
\renewcommand{\contentsname}{目\hspace{1em}录}
\renewcommand\tableofcontents{%
  \setlength{\@tempdima}{\parindent}
  \setlength{\parindent}{\z@}
  % 更新目录
  \renewcommand\userpartname{目录}
  \renewcommand\userchaptername{}
  \renewcommand\usersectionname{}
  \updatemark
  \chapter*{\contentsname
  %\@mkboth{\MakeUppercase 目錄}{\MakeUppercase 目錄}
  }%
  \@starttoc{toc}%
  \newpage
  \setlength{\parindent}{\@tempdima}
}

\def\@startsubtoc#1{
  \begingroup \makeatletter 
  \@input{\jobname.#1}
  \if@filesw 
    \expandafter\newwrite
    \csname tf@#1\endcsname 
    \immediate\openout
    \csname tf@#1\endcsname 
    \jobname.#1\relax 
  \fi 
  \@nobreakfalse 
  \endgroup
}

\newcommand{\tableofpartsname}{总\hspace{1em}目\hspace{1em}录}
\newcommand\tableofparts{%
  \chapter*{\tableofpartsname
  \@mkboth{%
  \MakeUppercase\tableofpartsname}{\MakeUppercase\tableofpartsname}}%
  \@startsubtoc{subtoc}%
  \newpage
}

% 目录的目录中的partname
\newcommand*\l@partname[2]{%
  \ifnum \c@tocdepth >-2\relax
    \addpenalty{-\@highpenalty}%
    \begingroup
    \parindent \z@ \rightskip \@pnumwidth
    \parfillskip -\@pnumwidth
    {\leavevmode
    #1\hfill \hb@xt@\@pnumwidth{\hss \zhdigits*{#2}}}\par
    \nobreak
    \global\@nobreaktrue
    \everypar{\global\@nobreakfalse\everypar{}}%
    \endgroup
  \fi
}

% 目录样式
\renewcommand*\l@part[2]{%
  \ifnum \c@tocdepth >-2\relax
    %\addpenalty{-\@highpenalty}%
    \begingroup
    \parindent \z@ \rightskip \@pnumwidth
    \parfillskip -\@pnumwidth
    {\leavevmode
    #1\hfill \hb@xt@\@pnumwidth{\hss \zhdigits*{#2}}}\par
    \nobreak
    \global\@nobreaktrue
    \everypar{\global\@nobreakfalse\everypar{}}%
    \endgroup
  \fi
  \addcontentsline{subtoc}{partname}{#1}%
}

\renewcommand*\l@chapter[2]{%
  \ifnum \c@tocdepth >\m@ne
    %\addpenalty{-\@highpenalty}%
    \begingroup
    \parindent \z@ \rightskip \@pnumwidth
    \parfillskip -\@pnumwidth % 解决chapter页码不对齐的问题
    {\leavevmode
    #1\nobreak\hfill \nobreak\hb@xt@\@pnumwidth{\hss \zhdigits*{#2}}\par
    %\penalty\@highpenalty
    }
    \endgroup
  \fi
}

\renewcommand*\l@section[2]{%
  \ifnum \c@tocdepth >\m@ne
    %\addpenalty{-\@highpenalty}%
    \begingroup
    \parindent \z@ \rightskip \@pnumwidth
    \parfillskip -\@pnumwidth % 解决chapter页码不对齐的问题
    {\leavevmode
    #1\nobreak\hfill \nobreak\hb@xt@\@pnumwidth{\hss \zhdigits*{#2}}\par
    %\penalty\@highpenalty
    }
    \endgroup
  \fi
}

% 自定义一个字号
\newcommand\littlesize{\@setfontsize\littlesize\@xpt\@xiipt}

% 封装表格命令
\newcommand\biao[3][]{%
  \par
  {\littlesize%使用小字体
  \linespread{1.0}\selectfont
  \begin{center}
  \begin{longtable}{#2}%
    \endfirsthead
    #1
    \endhead
    #3
  \end{longtable}
  \end{center}}
  \par%还原字体
}
