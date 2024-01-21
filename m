Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94F261E878;
	Sun, 21 Jan 2024 19:32:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705865581; cv=none; b=njbItTaC0GzXsm7y9cPNyZzatQfArzGigJYYFHVbj8nY75vD3QJAXUaKVrZaweR3TIET0Zr4mJxUBhSZp02MECjchb9fpJjso8QxdJT5Np0I3+3iXUqS2PwUWakSfHFt82nOqTMcvCexGqe/rxQhlRrgJnCLHw6SOsov5NJ3oCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705865581; c=relaxed/simple;
	bh=x9ow7Nm3zrs1bOY5+dYLtmTWweiQZJBV5FNPbcz89JU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=I48Y5Y4KnSMrUwxGBUYh1Lb1ZYDQvOKx11IDAHcSGddPPhSjvVY8keSMFiz9/0n7WoXzaCxccerSWntQ7icZFMj0EMeeHfrLBOWCWNGSpE0garq6jOjMhdtSj+2+Bizlzx8iRXasd2STMXtWhU9JkVU7OYjzWLkitmmMSgKAgXo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=efopudNB; arc=none smtp.client-ip=209.85.166.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="efopudNB"
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-36197b6e875so15371365ab.0;
        Sun, 21 Jan 2024 11:32:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1705865579; x=1706470379; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5509CI+m0+wO8fx5JQr9DE5fjRPuPGwVl19qE770/Fc=;
        b=efopudNBjgfBcilfxVNuNgPjS7K2nAB0gj2vwPEOmi5+V3OT26R/JiPSJ5/jUer8D8
         MExHv1S0wobDW5IdO3n9ZY1i8WlaHI/vLKZxkT5zHnLt5Qzh7dm44fUdgkLEWzRHWlZm
         ED6KcecRCkmmWtBKJjhGIVBTXJ1cMEpIigKPJmLuMvNsD9KlmHJdFb6c8uCh+QbdM+Qk
         7dQPRsY0BeN8fj/edpyddEEl95q/OXiiyHXHuEYpVusp+7M+9TzoYNbfzyeB/MsGKBsJ
         fGt8UAomnPliFa9AMYR2hDtr1Ch2D/PyiyPG2eStjCzpWA35wP4Xd+lQ+HQUCdjAWDNW
         SXYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705865579; x=1706470379;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5509CI+m0+wO8fx5JQr9DE5fjRPuPGwVl19qE770/Fc=;
        b=amTMhhCkq0KuoCppO0jtyuKLGDf6m56WVhDerHdW3wu3z5gemfwcFyXFY6cGJCw6dc
         7VcmGT16MZzaUsrxy0rYCmSwlzoSd5AVI0En/i8KgxnCMIxNBrtog6IzEW/DD4Y54NtP
         1k8FVkltc1lr3/lCKn4caO9OqNMio5xy4CuIHxefxPqIRidVMgdrktUvc3PqS6AqvfT9
         wPFdTwM7jU/fgxWqtYPalkLkrrWyqTA/7QLnXvR2Ni/k6vHY85eT8UM2fCAnd6cV8ReT
         9/rSMmgvy/5mCHgZtUcPtjegtWslPHrk8kdwIS5+CU5/c5suObkVwDqnkNkxxvThGdVy
         lmvA==
X-Gm-Message-State: AOJu0Yy5djh38wgs5bh94JscehyGAc6PUAf3+uXlct6GHgcRRTu2EJQL
	fu6goeyJ5ghCCY1ohy2fSlAmEv+Mh+EkULWlB5VWiwJX6vLWyDru
X-Google-Smtp-Source: AGHT+IHFU8zH+jPMhfNd5LmSkpYtsxHAec6bbMlyHxdT1cZRWOZHcJSS5btDeCkly0VrUq05VfWZ0w==
X-Received: by 2002:a92:d0cc:0:b0:35f:f707:3ec1 with SMTP id y12-20020a92d0cc000000b0035ff7073ec1mr4628615ila.32.1705865578661;
        Sun, 21 Jan 2024 11:32:58 -0800 (PST)
Received: from fedora-laptop (c-73-127-246-43.hsd1.nm.comcast.net. [73.127.246.43])
        by smtp.gmail.com with ESMTPSA id cv3-20020a056e023b8300b0035fb30380bcsm6981058ilb.58.2024.01.21.11.32.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 Jan 2024 11:32:58 -0800 (PST)
Date: Sun, 21 Jan 2024 12:32:53 -0700
From: Thomas Bertschinger <tahbertschinger@gmail.com>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Trevor Gross <tmgross@umich.edu>, linux-bcachefs@vger.kernel.org,
	bfoster@redhat.com, Miguel Ojeda <ojeda@kernel.org>,
	rust-for-linux@vger.kernel.org,
	Benno Lossin <benno.lossin@proton.me>
Subject: Re: packed, aligned structs in bcachefs (was: Re: [PATCH TOOLS 0/2]
 convert main() from C to Rust)
Message-ID: <20240121193253.GB151023@fedora-laptop>
References: <20240115052451.145611-1-tahbertschinger@gmail.com>
 <pawxsqxbjncrwtxytattvgizwrtmkis6suokgkb6wfm5xvsnhd@njjz4ywheu2a>
 <20240115175509.GA156208@fedora-laptop>
 <iiraqelv6wtwxcdf2yjtjt26ghejngfantjx7d4mztav27qu7y@gmiztxamveq3>
 <20240115191022.GC156208@fedora-laptop>
 <z7ajmttuzbvtxn4onwoxph6mevqt2rje2nga6cpux73geffias@p5kk7pqnswf6>
 <CALNs47t6qjYZeQKC+ahAaG6iNDGGNe8o+Q8tKhpRynYLWL3R8Q@mail.gmail.com>
 <gpokpnqgj6c2pcmtpiu46jy3kb3tom4xkp3fykg26zx6e3c2qe@zrnl2653qwsk>
 <20240121161124.GA151023@fedora-laptop>
 <cxben4yqhrraso7fiw54hj7wr4minkvxm7ibsh2yl4zew62jpy@xrraic3ceqns>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cxben4yqhrraso7fiw54hj7wr4minkvxm7ibsh2yl4zew62jpy@xrraic3ceqns>

On Sun, Jan 21, 2024 at 01:19:24PM -0500, Kent Overstreet wrote:
> On Sun, Jan 21, 2024 at 09:11:24AM -0700, Thomas Bertschinger wrote:
> > I made a script to compare the size and alignment of bcachefs structs
> > in C vs. in Rust generated by the patched, lossy bindgen. All sizes
> > were the same, but the following types had different alignment:
> > 
> That right there is really good news. If we can add that script to the
> tests in bcachefs-tools, we'll already be in better shape than we were.
> 
> I wonder if it would be possible to upstream that check into bindgen.

I did this with an awk script that grabs the structs from the bcachefs
C headers and outputs code in Rust and C to dump the sizes and
alignments. I then manually added calls to the generated functions into
the bcachefs utility and diffed the output. I'll try to get this into a
form more suitable for an automated test, and hopefully submit a patch
to bcachefs-tools soon...

Enhancing bindgen to do something like this automatically also sounds
like a good idea but it will take me longer to figure out how to do
that. I think it could also be good to incorporate explicit member
offset checks with this. Handling that with an awk script or similar
seems challenging to me with how bindgen mangles bitfield names.

> Also - you tracked down the difference between microsoft and gcc
> __attribute__((align)), let me try to recap (and tell me if I get it
> wrong): with gcc, __align() works like any naturally aligned type, but
> Microsoft's version overrides __packed on a containing structure.
> 
> I think there's a strong argument to be made that Microsoft is the weird
> one here and Rustc should just provide the gcc behaviour when mixing
> packed and align...

I don't have access to a Microsoft environment to test anything, so
everything that I think I know about Microsoft semantics is based on what
I've read on various rust-lang threads, like [1][2]

With that disclaimer, from what I can tell it seems like Microsoft's
semantics are strictly less expressive than gcc's. I think gcc can
represent any struct that Microsoft can (adding padding by hand
may be necessary in some cases, but it's always possible), whereas
there are structures representable in gcc that cannot be represented
with the Microsoft semantics as presented in the cited rust-lang
threads. (Given that I haven't tested the MS compiler, I could be
totally wrong about this.)

[1] https://github.com/rust-lang/rust/issues/59154#issuecomment-476408300
[2] https://github.com/rust-lang/rust/issues/33158

- Thomas Bertschinger
