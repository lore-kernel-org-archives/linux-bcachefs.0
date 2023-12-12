Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="z9w9EHoM"
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E535DD2
	for <linux-bcachefs@vger.kernel.org>; Mon, 11 Dec 2023 21:53:31 -0800 (PST)
Received: by mail-pg1-x535.google.com with SMTP id 41be03b00d2f7-5bcfc508d14so4395526a12.3
        for <linux-bcachefs@vger.kernel.org>; Mon, 11 Dec 2023 21:53:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1702360411; x=1702965211; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jKqOBIedlSsY4nBkWI82g8jPO85sii/44Gnqq6ID1O0=;
        b=z9w9EHoMcBwO88sgKcuVsU/HhPi+z1X/0J1QfvzFMypNKhmsdBHIX2KmZRbijQ424w
         WQI8p5qiAitMCtkJnDArn+tPFyBUlsg0+rGhwHn5KU9B55Rtk7N7wypT0Ak5y+znR5bW
         c6CZwk6H/C/UM7F5mtZH8uNB+JPmrSs6rfBK48QBJn5JRHOuUizxHpkqF0E2cV+K6Y3S
         AltXW2bB2kkItw7KgM3ZLtjeaZ9oCKqGdG1eJok+CMne6ql1Y/KVfs6wZGyiTg6wz6SN
         S+xYMGm64gav5/abtnz1wD+MhGKchpiDVSq8hqWGWx9gv50moGD1myrcAkCVnV0HRg/z
         j7xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702360411; x=1702965211;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jKqOBIedlSsY4nBkWI82g8jPO85sii/44Gnqq6ID1O0=;
        b=jH8UCcF5fhAvKIwnu+nDuSMCXn4/faGshJxsDo4JWKn2kkdGuX5++4PzlVda5tJNWE
         0/NLgGMWdkJE2t7zLtb/Sa9mf1hK3zmmdoK0LT0y1gInOfSHXt8i09DPbLi1LF7CsVUe
         RFccw4NyrmOQ5QAInBOd9gVY1AzLJ/Xo3l6epL/mD4F1sk7sbaf4TdKFL0UCIbZLi2ag
         4qE8J0wd6O2Ez9QdIQWBGehr0nJMBwNjxNrA4PKMidyjx6ggQj83IpDoPuk97BjeEFgj
         ChRl4C5mmlJNruTZHzxHc6SFdFYDQplemp1/vxP0XRID8gefRaqp5Cm2POmaFvPBYjiQ
         y+SA==
X-Gm-Message-State: AOJu0YxAL0eS01Ox/4BlIcogFGSTyolcrE7jVlOMjQi98PAyBLqv31qR
	U0ua2jFT6A8x87S29kpFw0/BPg==
X-Google-Smtp-Source: AGHT+IFNMdmcLLW9monbbEC6emitbzMai6XS5PZWnbznSerDkEEY58O7eOR3Q77jdDbkRAR0c8/x4w==
X-Received: by 2002:a05:6a20:e125:b0:190:230:8e8b with SMTP id kr37-20020a056a20e12500b0019002308e8bmr7280439pzb.105.1702360411404;
        Mon, 11 Dec 2023 21:53:31 -0800 (PST)
Received: from dread.disaster.area (pa49-180-125-5.pa.nsw.optusnet.com.au. [49.180.125.5])
        by smtp.gmail.com with ESMTPSA id d3-20020a170903230300b001d08bbcf78bsm7673902plh.74.2023.12.11.21.53.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Dec 2023 21:53:30 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rCvhw-007AkC-0p;
	Tue, 12 Dec 2023 16:53:28 +1100
Date: Tue, 12 Dec 2023 16:53:28 +1100
From: Dave Chinner <david@fromorbit.com>
To: NeilBrown <neilb@suse.de>
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	Donald Buczek <buczek@molgen.mpg.de>,
	linux-bcachefs@vger.kernel.org,
	Stefan Krueger <stefan.krueger@aei.mpg.de>,
	David Howells <dhowells@redhat.com>, linux-fsdevel@vger.kernel.org
Subject: Re: file handle in statx (was: Re: How to cope with subvolumes and
 snapshots on muti-user systems?)
Message-ID: <ZXf1WCrw4TPc5y7d@dread.disaster.area>
References: <20231208013739.frhvlisxut6hexnd@moria.home.lan>
 <170200162890.12910.9667703050904306180@noble.neil.brown.name>
 <20231208024919.yjmyasgc76gxjnda@moria.home.lan>
 <630fcb48-1e1e-43df-8b27-a396a06c9f37@molgen.mpg.de>
 <20231208200247.we3zrwmnkwy5ibbz@moria.home.lan>
 <170233460764.12910.276163802059260666@noble.neil.brown.name>
 <20231211233231.oiazgkqs7yahruuw@moria.home.lan>
 <170233878712.12910.112528191448334241@noble.neil.brown.name>
 <20231212000515.4fesfyobdlzjlwra@moria.home.lan>
 <170234279139.12910.809452786055101337@noble.neil.brown.name>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170234279139.12910.809452786055101337@noble.neil.brown.name>

On Tue, Dec 12, 2023 at 11:59:51AM +1100, NeilBrown wrote:
> On Tue, 12 Dec 2023, Kent Overstreet wrote:
> > On Tue, Dec 12, 2023 at 10:53:07AM +1100, NeilBrown wrote:
> > > On Tue, 12 Dec 2023, Kent Overstreet wrote:
> > > > On Tue, Dec 12, 2023 at 09:43:27AM +1100, NeilBrown wrote:
> > > > > On Sat, 09 Dec 2023, Kent Overstreet wrote:
> > > > Thoughts?
> > > > 
> > > 
> > > I'm completely in favour of exporting the (full) filehandle through
> > > statx. (If the application asked for the filehandle, it will expect a
> > > larger structure to be returned.  We don't need to use the currently
> > > reserved space).
> > > 
> > > I'm completely in favour of updating user-space tools to use the
> > > filehandle to check if two handles are for the same file.
> > > 
> > > I'm not in favour of any filesystem depending on this for correct
> > > functionality today.  As long as the filesystem isn't so large that
> > > inum+volnum simply cannot fit in 64 bits, we should make a reasonable
> > > effort to present them both in 64 bits.  Depending on the filehandle is a
> > > good plan for long term growth, not for basic functionality today.
> > 
> > My standing policy in these situations is that I'll do the stopgap/hacky
> > measure... but not before doing actual, real work on the longterm
> > solution :)
> 
> Eminently sensible.
> 
> > 
> > So if we're all in favor of statx as the real long term solution, how
> > about we see how far we get with that?
> > 
> 
> I suggest:
> 
>  STATX_ATTR_INUM_NOT_UNIQUE - it is possible that two files have the
>                               same inode number
> 
>  
>  __u64 stx_vol     Volume identifier.  Two files with same stx_vol and 
>                    stx_ino MUST be the same.  Exact meaning of volumes
>                    is filesys-specific
>  
>  STATX_VOL         Want stx_vol
> 
>   __u8 stx_handle_len  Length of stx_handle if present
>   __u8 stx_handle[128] Unique stable identifier for this file.  Will
>                        NEVER be reused for a different file.
>                        This appears AFTER __statx_pad2, beyond
>                        the current 'struct statx'.
>  STATX_HANDLE      Want stx_handle_len and stx_handle. Buffer for
>                    receiving statx info has at least
>                    sizeof(struct statx)+128 bytes.

Hmmm.

Doesn't anyone else see or hear the elephant trumpeting loudly in
the middle of the room?

I mean, we already have name_to_handle_at() for userspace to get a
unique, opaque, filesystem defined file handle for any given file.
It's the same filehandle that filesystems hand to the nfsd so nfs
clients can uniquely identify the file they are asking the nfsd to
operate on.

The contents of these filehandles is entirely defined by the file
system and completely opaque to the user. The only thing that
parses the internal contents of the handle is the filesystem itself.
Therefore, as long as the fs encodes the information it needs into the
handle to determine what subvol/snapshot the inode belongs to when
the handle is passed back to it (e.g. from open_by_handle_at()) then
nothing else needs to care how it is encoded.

So can someone please explain to me why we need to try to re-invent
a generic filehandle concept in statx when we already have a
have working and widely supported user API that provides exactly
this functionality?

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
