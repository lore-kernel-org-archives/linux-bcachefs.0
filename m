Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1392D221557
	for <linux-bcachefs@vger.kernel.org>; Tue, 29 Apr 2025 15:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745941019; cv=none; b=qf/yczDPXaXnMz01fdl3FIK14U6hWXWIDkQhZZibTL4NIuw1kmjMJSaMZ91IyCYk9Clt2vlb1a/AOrgS69y54kP7RmbzZPZGFbRejTMb27R3WC13dEVj/xlFhre16AXjROt4mUNlR8wilptX7bbeesiMHfkpz4FA9sZzSXLq/Ro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745941019; c=relaxed/simple;
	bh=3usbEIK+Vf0eiZW7mghNbw6ET31WZBrHVcaTo5PhsD4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GLu8AquPVQKkPzAdwKk4ZiZmbM6LiTCATQTlUWPInkT8jFrXKzVNCvKxxoB9cVA9oE2nb2frsf4tIs8kuvVSCDaBDSmE6LFqO9XSp2KEWzNgxY6H7RUbed+WiewMYLhaa6zFBjLyGx55fvHxhQ6kuZJS/+ZM4YU+Ywu0LSYkcCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=batbytes.com; spf=none smtp.mailfrom=batbytes.com; dkim=pass (2048-bit key) header.d=batbytes-com.20230601.gappssmtp.com header.i=@batbytes-com.20230601.gappssmtp.com header.b=Ju/5DHQ3; arc=none smtp.client-ip=209.85.215.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=batbytes.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=batbytes.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=batbytes-com.20230601.gappssmtp.com header.i=@batbytes-com.20230601.gappssmtp.com header.b="Ju/5DHQ3"
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-b0b2d0b2843so5202633a12.2
        for <linux-bcachefs@vger.kernel.org>; Tue, 29 Apr 2025 08:36:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=batbytes-com.20230601.gappssmtp.com; s=20230601; t=1745941016; x=1746545816; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1ebRG7jeBkWEyD/xAGDvW23IxuEay2SS0xU4F/+a64M=;
        b=Ju/5DHQ3nXPb+Y6F0ChYlavpte/IBmFRnebMTJ78WCHR82EIk6eSeTt2n/dGU197+t
         xj5+52sL3/iIZW4MhXj7mejF8s/esJ+CkX5p24Rnhi1dgDTdy1lW74TeAbrUGuXxkfiJ
         iaY45Knz00Ima1O/KB723NvbmgDv47DYAZIzOGuQVerE5il3N+n1/BqHxKXjzPECaq87
         mKzXZ+tyylYHaZAwiDC9WAhOYo1BG+MufftOFsDS1DayBDkq1KS1VixmedXzmZB9+gz0
         ip2RUfM2VBtkKxtdPoz2Uw/poqcYrFDO34R6//QZ9phxBAfgmyjzzdoEJhhOdcBi62wg
         WUmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745941016; x=1746545816;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1ebRG7jeBkWEyD/xAGDvW23IxuEay2SS0xU4F/+a64M=;
        b=nRFPosnPXFsOpYQFKB/PtN7G5UawHz/4PxWRBWPujzU54+sh1TPdvHOYBKYXKL41+j
         hhS/ddtiLp0s3HVdu1Ee7m1zVg4P/3NSDKW6bPcLcfFjXmFJ1+16ygK1wGhaVVR/wlNF
         AZI8RwiJC5MswOBPZP1VRpNFiGtY9pzJnqF2DysIueM+OHLRE2t8OrHCOxj2pO/TeR0S
         7fIizJHL69iPVA+qDa7U1VCFnn/jKVZ8n6NJ6wN5V/sjgNz3aN9xCf7Ff8xsLj+QsCKp
         OHw5UJ/ThTI/4wazFXA27f70zbK2rhVRCjb7OAT8yBVH5NTlHEZFeOFy1gpk7tXePf3z
         lEdw==
X-Forwarded-Encrypted: i=1; AJvYcCUF9cveD7yXCDnThklWbNeEY2dEWKWsTYTYce4DT1ajXbI7eX0iSE/2Pm55DEM9n1thqWdHwhLrsBYW57LlDw==@vger.kernel.org
X-Gm-Message-State: AOJu0YxTCn98XBvt3ZgkcqSTgwX4ZgaB7OekSdXFB55E1DvFjmbqmkm7
	zOYLFO8cUkCDl1rb0UsB45SXgpuqNpPInhTdTSNjefp3mZMcbvpORVb8Cq33nHlqnWtRF2G7M6C
	e7srImt4eD1dn3WT5B/GAFZHmHItzi+10QJ2R
X-Gm-Gg: ASbGncsNFsm7g/r3uE14zKMr9E3pRMo6fQA0GlmvCDUjEdwqL2DgGfpmtJcjnefYkVa
	iIEGOzhqlcHIuXPRtHgaXMPkvTNN7EsT4CznYmgm5fqBnh9ww/AMnYIkini8XKReJXxOS+eMhvA
	Nk+h14FJ7gYMGbTKSY2S/jRU0ALnVM+sqi
X-Google-Smtp-Source: AGHT+IEXBqEgt3qTlVv+o57ePa/sffj59yz152ICUQH8M50uSy4IOzvgJ/912q7YAwzI9BcMfF3zbK4OLOx/mI6NTK0=
X-Received: by 2002:a17:90b:4fc2:b0:2ff:58c7:a71f with SMTP id
 98e67ed59e1d1-30a2214c2famr4603260a91.32.1745941016193; Tue, 29 Apr 2025
 08:36:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <l7pfaexlj6hs56znw754bwl2spconvhnmbnqxkju5vqxienp4w@h2eocgvgdlip>
 <CAHk-=wjajMJyoTv2KZdpVRoPn0LFZ94Loci37WLVXmMxDbLOjg@mail.gmail.com>
 <ivvkek4ykbdgktx5dimhfr5eniew4esmaz2wjowcggvc7ods4a@mlvoxz5bevqp>
 <CAHk-=wg546GhBGFLWiuUCB7M1b3TuKqMEARCXhCkxXjZ56FMrg@mail.gmail.com>
 <q3thzkbsq6bwur7baoxvxijnlvnobyt6cx4sckonhgdkviwz76@45b6xlzvrtkr>
 <CAHk-=wh09TvgFu3WKaeLu8jAxCmwZa24N7spAXi=jrVGW7X9ZA@mail.gmail.com>
 <mlsjl7qigswkjvvqg2bheyagebpm2eo66nyysztnrbpjau2czt@pdxzjedm5nqw>
 <CAHk-=wiSXnaqfv0+YkOkJOotWKW6w5oHFB5xU=0yJKUf8ZFb-Q@mail.gmail.com>
 <lmp73ynmvpl55lnfym3ry76ftegc6bu35akltfdwtwtjyyy46z@d3oygrswoiki> <CAHk-=wiZ=ZBZyKfg-pyA3wmEq+RkscKB1s68c7k=3GaT48e9Jg@mail.gmail.com>
In-Reply-To: <CAHk-=wiZ=ZBZyKfg-pyA3wmEq+RkscKB1s68c7k=3GaT48e9Jg@mail.gmail.com>
From: Patrick Donnelly <batrick@batbytes.com>
Date: Tue, 29 Apr 2025 11:36:44 -0400
X-Gm-Features: ATxdqUHuC157o0Nat5aBHJKsyiSBROfN1gD_06S9513asTF0ToaHKcRLVgAt2Tk
Message-ID: <CACh33FqQ_Ge6y0i0nRhGppftWdfMY=SpGsN0EFoy9B8VMgY-_Q@mail.gmail.com>
Subject: Re: [GIT PULL] bcachefs fixes for 6.15-rc4
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Kent Overstreet <kent.overstreet@linux.dev>, linux-bcachefs@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hello,

I'm one of the maintainers of the Ceph file system (CephFS). I
recently introduced case-insensitive directory trees into CephFS to
support performance improvements for Samba. Perhaps my experience
would add to this timely discussion.

[

A brief context/background on that effort for those interested:

CephFS has an inherited (at mkdir) metadata on directories which adds
"normalization" (string: unicode normalization type) or
"casesensitive" (bool) which permanently affects how dentries are
looked up. The directory must be empty and free of snapshots to change
this metadata ("charmap").

Clients with support for this feature will perform a mapping [1] from
the application (userspace libcephfs or ceph-fuse) path namespace to
the MDS (metadata server) path namespace during a path walk or lookup.
For affected directories, the MDS namespace is the normalized and
possibly case-folded name for each dentry. The MDS also stores an
uninterpreted "alternate_name" with each dentry that is the original
name from the application namespace used to create the dentry. The
alternate_name is **only** visible via file system operations that
expose dentry names to the application, readdir/getcwd [2].

Benefits I identified for this approach were:

- The core file system (mainly: MDS) paths were virtually unchanged.
The MDS does not care about case sensitivity or normalization. It uses
what the client gave it for the dentry name.
- It's the client's job to perform any namespace mapping and store
metadata in alternate_name to reverse the mapping (i.e. get the
original dentry name used to create the dentry).
- The Client's cache uses the same file system namespace as the MDS:
dentry names are normalized/case-folded. The transformation is only
applied during path walk / lookup with user-supplied paths/names.

We use libicu (indirectly through boost) for actually doing the
normalization / casefolding. It's simple [3]. It works. Despite your
(Linus) objections to this in prior postings, I do not see this as
problematic. There are backwards compatibility guarantees in the
standard [4].  Does that mean mistakes can't happen? No. Certainly
there could be a backwards-compatibility breakage where we have two
physical dentries with names that should be equivalent: one dentry
shadows the other for some clients with upgraded Unicode tables. Even
so, I do not see this as significant barrier to adopting the Unicode
routines. In my opinion, the real danger is a file system person
foolishly thinking they know best by rolling their own mapping table
and discovering why that's a terrible idea. I think this thread
illustrates that in several places.

]

On Fri, Apr 25, 2025 at 11:41=E2=80=AFPM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Fri, 25 Apr 2025 at 20:09, Kent Overstreet <kent.overstreet@linux.dev>=
 wrote:
> >
> > The subject is CI lookups, and I'll eat my shoe if you wrote that.
>
> Start chomping. That nasty code with d_compare and d_hash goes way back.
>
> From a quick look, it's from '97, and got merged in in 2.1.50. It was
> added (obviously) for FAT. Back then, that was the only case that
> wanted it.
>
> I don't have any archives from that time, and I'm sure others were
> involved, but that whole init_name_hash / partial_name_hash /
> end_name_hash pattern in 2.1.50 looks like code I remember. So I was
> at least part of it.
>
> The design, if you haven't figured it out yet, is that filesystems
> that have case-independent name comparisons can do their own hash
> functions and their own name comparison functions, exactly so that one
> dentry can match multiple different strings (and different strings can
> hash to the same bucket).
>
> If you get dentry aliases, you may be doing something wrong.

I would not consider myself a kernel developer but I assume this
terminology (dentry aliases) refers to multiple dentries in the dcache
referring to the same physical dentry on the backing file system?

If so, I can't convince myself that's a real problem. Wouldn't this be
beneficial because each application/process may utilize a different
name for the backing file system dentry? This keeps the cache hot with
relevant names without any need to do transformations on the dentry
names. Happy to learn otherwise because I expected this situation to
occur in practice with ceph-fuse. I just tested and the dcache entries
(/proc/sys/fs/dentry-state) increases as expected when performing case
permutations on a case-insensitive file name. I didn't observe any
cache inconsistencies when editing/removing these dentries. The danger
perhaps is cache pollution and some kind of DoS? That should be a
solvable problem but perhaps I misunderstand some complexity.

> Also, originally this was all in the same core dcache lookup path. So
> the whole "we have to check if the filesystem has its own hash
> function" ended up slowing down the normal case. It's obviously been
> massively modified since 1997 ("No, really?"), and now the code is
> very much set up so that the straight-line normal case is all the
> non-CI cases, and then case idnependence ends up out-of-line with its
> own dcache hash lookup loops so that it doesn't affect the normal good
> case.

It's seems to me this is a good argument for keeping case-sensitivity
awareness out of the dcache. Let the fs do the namespace mapping and
accept that you may have dentry aliases.

FWIW, I also wish we didn't have to deal with case-sensitivity but we
have users/protocols to support (as usual).

[1] https://github.com/ceph/ceph/blob/ebb2f72bfc37577d5389809ba0c16fca032ac=
d8a/src/client/Client.cc#L7732-L7735
[2] https://github.com/ceph/ceph/blob/ebb2f72bfc37577d5389809ba0c16fca032ac=
d8a/src/client/Client.cc#L1353
[3] https://github.com/ceph/ceph/blob/ebb2f72bfc37577d5389809ba0c16fca032ac=
d8a/src/client/Client.cc#L1299-L1340
[4] https://unicode.org/reports/tr15/#Versioning

Kind regards,

--
Patrick Donnelly
