Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HeL9m9vY"
Received: from mail-vs1-xe32.google.com (mail-vs1-xe32.google.com [IPv6:2607:f8b0:4864:20::e32])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64733196
	for <linux-bcachefs@vger.kernel.org>; Tue,  5 Dec 2023 15:26:27 -0800 (PST)
Received: by mail-vs1-xe32.google.com with SMTP id ada2fe7eead31-4648ce39399so881988137.3
        for <linux-bcachefs@vger.kernel.org>; Tue, 05 Dec 2023 15:26:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701818786; x=1702423586; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ykFOGtaPMrHDI7lxAojWgRl8Vg/JBJk+1ptRaFtzUXQ=;
        b=HeL9m9vYUJmCQhPMe4gzyYNBkXSsFc16yKEdvXlDEtllT77kBmAC3vO5VqdT02uoW3
         ejY/E20AGfnL12gNSxWmJ/SP4USdWSfr4ftcDFRGymXKVwkZHETAmgPdGFb4j4BCgFSb
         IOh6Up/JJBYhKYXMX2o9mkZQopX6Fb7dIO3e+WqxBmwv3As4Ab8NP/DxWa8Z3wt76gG6
         5KLoziJLH7rZTkbxVGoX4YpVgvyyxMxgw/Rpkox7ke8l/Nk75wNyAjO5DYQY/NH0ZRf4
         J0P3nNTyvlyRzaWSxzF+Uipg6HtSs+lw2zO5e9bYMPneh4yosqAidAclROO2BrSy5KLD
         omMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701818786; x=1702423586;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ykFOGtaPMrHDI7lxAojWgRl8Vg/JBJk+1ptRaFtzUXQ=;
        b=bV8GvLziYN7BWWyfatxYoJLO4F71EreuJ0Q3TNlhB5kZR0Y4eMLImWkUq3NiRGr5Yt
         rR05Ge1fIo4mwvZlkIYjFq3AfwUw8DQLZ+H+qrUqiMtygN6tX3MvtTUNClwZQETVnPJR
         KdazEO5Z8QXY22Y2i/+IytwSkP+4Hh8pWeaEGpxhr5aWT5oc9kyFCFZVvLV1CX0O0SEr
         41JBonF5lRCrZ3Wbtz8AQxNyuAMq5M58zLppbEJcbZvLUmmwjr/FQD91epncTZyr9PPW
         bKzEVf1F8Bg3ZcEVj+C8ZB2WM1mNl714r7QFjVJiVVAXqPi+H/Z46Vy6w/EHpSei8YWT
         W9Pw==
X-Gm-Message-State: AOJu0YxHcwfpI26/n/9tlBLNlzkiYz1D/kdpCFcRhPQbSIgs3JL+hiXm
	prwKBRhSzVuP86FK+xu2YNF347fyAY59YGEOONR1UC+0
X-Google-Smtp-Source: AGHT+IGqidhgjUbOC2o4bJwOJgx4CxG6WF9TTujqLFtI5mnZXYvqK7AVAc063zPKmkXfAByGZh1YlsaaClTS4AOVtYA=
X-Received: by 2002:a05:6102:2da:b0:464:57e5:ad01 with SMTP id
 h26-20020a05610202da00b0046457e5ad01mr42955vsh.17.1701818786223; Tue, 05 Dec
 2023 15:26:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAHLWS5EiGVn_-BFm2X1PKZ2m0EJq6VjckLdOuVqL2zWibxYUqA@mail.gmail.com>
 <ZW85rKUfEXeaWqsL@bfoster>
In-Reply-To: <ZW85rKUfEXeaWqsL@bfoster>
From: Steve Smith <tarkasteve@gmail.com>
Date: Wed, 6 Dec 2023 10:26:14 +1100
Message-ID: <CAHLWS5GOqsSZH5rZ4yobzUH+RbhznoQW0z1E_T=rTTJAXqXVTw@mail.gmail.com>
Subject: Re: [bug]: fiemap returns zero extents for all files
To: Brian Foster <bfoster@redhat.com>
Cc: linux-bcachefs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Brian,

Thanks for the suggestion. Yes, the ioctl call that xfs_io makes is
basically identical to the one the test makes, except it has the SYNC
flag set. Adding this flag (or calling fsync) results in expected
behaviour (mapped_extents > 0).

I assume that the bcachefs fiemap impl ignores unwritten data and only
responds with flushed extents? I'm not sure if this is correct; for
comparison, XFS, Btfs, zfs, and ext4, all return the extent map
immediately after write without syncing.

You're right that bcachefs seems to split extents that would be
contiguous on some other FSs, but that's fine here.

Thanks,
Steve



On Wed, 6 Dec 2023 at 01:53, Brian Foster <bfoster@redhat.com> wrote:
>
> On Tue, Dec 05, 2023 at 04:26:40PM +1100, Steve Smith wrote:
> > Hi,
> >
> > I'm doing some testing of xcp[1] against bcachefs, and having issues
> > with fiemap. Using fiemap on both sparse and non-sparse files always
> > returns `mapped_extents` of 0. The same tests on other extent-based
> > FSs return non-zero extents, with consistent values. This is against
> > -rc4 and master.
> >
> > I've broken the relevant tests (in Rust) out into a standalone crate
> > if you want to reproduce:
> >
> >     https://github.com/tarka/bcachefs-test
> >
> > The FS in question was created with a simple `bcachefs -L xcp-test /dev/sdh1`.
> >
>
> Hi Steve,
>
> Well I'm not really familiar with xcp or your test harness here, but
> have you checked the results you're seeing against known working tools?
> For example, one of the subtests just seems to perform a simple write
> followed by an fiemap check/assert for a single extent. That is roughly
> equivalent to:
>
> # xfs_io -fc "pwrite 0 128k" -c "fiemap -v" ./file
> wrote 131072/131072 bytes at offset 0
> 128 KiB, 32 ops; 0.0011 sec (108.790 MiB/sec and 27850.3046 ops/sec)
> ./file:
>  EXT: FILE-OFFSET      BLOCK-RANGE      TOTAL FLAGS
>    0: [0..127]:        339968..340095     128   0x0
>    1: [128..255]:      340096..340223     128   0x1
>
> ... which mostly seems to DTRT. I have noticed in the past that bcachefs
> fiemap seems to break extents into bucket size or some such segments,
> regardless of contiguity, but this doesn't seem to be the issue you are
> reporting here. I.e. an strace of the above shows the following for the
> fiemap ioctl():
>
> ioctl(3, FS_IOC_FIEMAP, {fm_start=0, fm_length=18446744073709551615, fm_flags=FIEMAP_FLAG_SYNC, fm_extent_count=32} => {fm_flags=FIEMAP_FLAG_SYNC, fm_mapped_extents=2, ...}) = 0
>
> ... which shows fm_mapped_extents == 2. Hm?
>
> Brian
>
> > Cheers,
> > Steve
> >
> > [1]: https://github.com/tarka/xcp
> >
>
