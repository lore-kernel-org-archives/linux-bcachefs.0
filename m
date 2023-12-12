Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="z2zxaXfJ"
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2027124
	for <linux-bcachefs@vger.kernel.org>; Tue, 12 Dec 2023 12:59:57 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id d2e1a72fcca58-6ce72730548so5445846b3a.1
        for <linux-bcachefs@vger.kernel.org>; Tue, 12 Dec 2023 12:59:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1702414797; x=1703019597; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1TFj+nPMCBJRUEJv9FZ9rBev17ciAyH+y7gTlG6mTkE=;
        b=z2zxaXfJoIHYd+hKcZJ653U7wphLutML+BQCOqes99fpeuArUWZBaP+kKGXpwycXlZ
         mGtWJwDsR2f9UBy+bSqeADkcmfiUiGrR44lGFgy62losXpUXz5U+yokgN2T8EL4TSYns
         WTfLTdXHoML/pScvf1nT9Epz0utO+oWalQTV24Fh1HyTGNc27RiuzwNCwSVBqXTwgHKb
         6XMepL9EsilMpyv84GA7MlvNhwg/Q1BGu2n0eM9TX4iIU7oLuWaISqYGSOgdNsWb1/WW
         /P8pYuf4FMn/RQ+tgRTnBZalMftVqhaGSBnJXZofNG3qX5jthfWn/3GZkSGTCtmkHTiJ
         C+gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702414797; x=1703019597;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1TFj+nPMCBJRUEJv9FZ9rBev17ciAyH+y7gTlG6mTkE=;
        b=s5UaTjH/NcmiHcbKhQo9XdlbkbcbHJ4/2IDY5FqdS8ha887pI+rloIcLJ8o7Tz554H
         HFE8Ym6Bu5iFW9SRQxInUZ9vKu2EBy4VuslKszlbGjEWhJRHkNSXSjedNisBcm4adT7N
         DzoKtBBiCvWmKJw9b2Un7Py7YQOIVFVdjkJS9s0if63tRjEFc9sK4dhCIsMdx/C0CFkp
         AHm5AifNO1kBi1Jrnif0WhTumeDRgYulaYr5WzT3RU8Ns6MaLpBnPsXYGugff2zZ7jKY
         bII9A8m6dvvPJw+V0kdKFUjLouzlgVf+/NiLv9ELXtiNoWGfyQAafKFutyXopriu+dL7
         isPQ==
X-Gm-Message-State: AOJu0Yy+iwORNbRbGSYWMuoZNK0Yu+JvBVTx7ro2/FVbGHPAChOlt7nW
	KCfm9plU55lyfxEnc35W8qKLXA==
X-Google-Smtp-Source: AGHT+IHo4OV80XxtQHh/fyOsH8oROXcusznX1A/+AW19uX4mpaHwEW94Juh/ZIVldIj4Efz4CxcQTw==
X-Received: by 2002:a05:6a00:22d0:b0:6ce:450c:6586 with SMTP id f16-20020a056a0022d000b006ce450c6586mr11075549pfj.26.1702414797181;
        Tue, 12 Dec 2023 12:59:57 -0800 (PST)
Received: from dread.disaster.area (pa49-180-125-5.pa.nsw.optusnet.com.au. [49.180.125.5])
        by smtp.gmail.com with ESMTPSA id r15-20020aa78b8f000000b006cdd82337bcsm8596762pfd.207.2023.12.12.12.59.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Dec 2023 12:59:56 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rD9r8-007ST5-26;
	Wed, 13 Dec 2023 07:59:54 +1100
Date: Wed, 13 Dec 2023 07:59:54 +1100
From: Dave Chinner <david@fromorbit.com>
To: Frank Filz <ffilzlnx@mindspring.com>
Cc: 'Theodore Ts'o' <tytso@mit.edu>, 'Donald Buczek' <buczek@molgen.mpg.de>,
	'NeilBrown' <neilb@suse.de>,
	'Kent Overstreet' <kent.overstreet@linux.dev>,
	linux-bcachefs@vger.kernel.org,
	'Stefan Krueger' <stefan.krueger@aei.mpg.de>,
	'David Howells' <dhowells@redhat.com>,
	linux-fsdevel@vger.kernel.org
Subject: Re: file handle in statx
Message-ID: <ZXjJyoJQFgma+lXF@dread.disaster.area>
References: <20231208200247.we3zrwmnkwy5ibbz@moria.home.lan>
 <170233460764.12910.276163802059260666@noble.neil.brown.name>
 <20231211233231.oiazgkqs7yahruuw@moria.home.lan>
 <170233878712.12910.112528191448334241@noble.neil.brown.name>
 <20231212000515.4fesfyobdlzjlwra@moria.home.lan>
 <170234279139.12910.809452786055101337@noble.neil.brown.name>
 <ZXf1WCrw4TPc5y7d@dread.disaster.area>
 <e07d2063-1a0b-4527-afca-f6e6e2ecb821@molgen.mpg.de>
 <20231212152016.GB142380@mit.edu>
 <0b4c01da2d1e$cf65b930$6e312b90$@mindspring.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0b4c01da2d1e$cf65b930$6e312b90$@mindspring.com>

On Tue, Dec 12, 2023 at 09:15:29AM -0800, Frank Filz wrote:
> > On Tue, Dec 12, 2023 at 10:10:23AM +0100, Donald Buczek wrote:
> > > On 12/12/23 06:53, Dave Chinner wrote:
> > >
> > > > So can someone please explain to me why we need to try to re-invent
> > > > a generic filehandle concept in statx when we already have a have
> > > > working and widely supported user API that provides exactly this
> > > > functionality?
> > >
> > > name_to_handle_at() is fine, but userspace could profit from being
> > > able to retrieve the filehandle together with the other metadata in a
> > > single system call.
> > 
> > Can you say more?  What, specifically is the application that would want
> to do
> > that, and is it really in such a hot path that it would be a user-visible
> > improveable, let aloine something that can be actually be measured?
> 
> A user space NFS server like Ganesha could benefit from getting attributes
> and file handle in a single system call.

At the cost of every other application that doesn't need those
attributes. That's not a good trade-off - the cost of a syscall is
tiny compared to the rest of the work that has to be done to create
a stable filehandle for an inode, even if we have a variant of
name_to_handle_at() that takes an open fd rather than a path.

> Potentially it could also avoid some of the challenges of using
> name_to_handle_at that is a privileged operation.

It isn't. open_by_handle_at() is privileged because it bypasses all
the path based access checking that a normal open() does. Anyone can
get a filehandle for a path from the kernel, but few can actually
use it for anything other than file uniqueness checks....

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
