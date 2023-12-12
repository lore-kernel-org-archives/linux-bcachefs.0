Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="rnizlVkM"
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 621B4CE
	for <linux-bcachefs@vger.kernel.org>; Tue, 12 Dec 2023 15:06:41 -0800 (PST)
Received: by mail-il1-x135.google.com with SMTP id e9e14a558f8ab-35f56f06142so11905785ab.1
        for <linux-bcachefs@vger.kernel.org>; Tue, 12 Dec 2023 15:06:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1702422400; x=1703027200; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=gPu9OJuRoySeT6EQUZCVlx9vnkyIloc86JjG7P6vc+4=;
        b=rnizlVkMC5LcjPS/94T3Urj950B5q8MjXxnTLmWadc3jH28DFSnfFBPo+j88nEYwu2
         TbWlLCP/MekvQCKH6/3OYumIHvIcOiuGSfTrQ56GLZO8JenkwJMq6O63ozCObsbn6bPk
         QuYu7KX07sys6gTK+NXAGbwEGwsgtdlP5rqHwI9BS3Wm4T3w1EudiVyzcgtQ6IZPUFo9
         KvnuoksO0zFBYzrk0Bse1Y9TfTLdrXeZiuQn4vwc49UM09Zv0ZtXyx+7kQ8Xw5sethJC
         o7RFKYCSlKvjSbK/xb7Dy/D9vdRm7XXFUn1CbFTA4C57mJ0HW7aGwiHpSmBRG0Rkdt9Y
         Mcfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702422401; x=1703027201;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gPu9OJuRoySeT6EQUZCVlx9vnkyIloc86JjG7P6vc+4=;
        b=jVwrb9ysHfmPGsMx8OhKs3i/NQ8LxoOMy5ttS/szRfzIaNeqEWc/dUd+tqH+2KoZTo
         +W3Fp0Ek4fslfRBUTzbjC2FpGbc2qoXPbprl2246uY2VIYMZoLRo0W4PT13kTONkdMSt
         GA1UXVGnqis9ONz/A+YZ9H5HhhC2u3Qye9hw2kdepa3Wn64/leDdLz8OfNPS6S9+YWkQ
         KSxuvFoZns6mBIT1rNKw7ihidRya/tDAbVbwKW+RTa5pFI/L/53bsf3nivvnP9Ruxl/M
         +GbFixGQwSRjGmihdXNv3DYU9N6S0D8u6FM/VbiWbE5oL4xJ8TlF6XzJ/pKx49hdpijw
         d4uw==
X-Gm-Message-State: AOJu0YyfEwQh4/Gd6+kcoFpf3wV1c7mKv5vfL4cYCpDDwwzwgNLKaJ6D
	ke9zDLROxR86IRWGKss6z0uXIWxeoIxCNrBoRsA=
X-Google-Smtp-Source: AGHT+IGDEkxi5C9eKXRu2Df4eSKaVBRfjiKd3GCoS0nCA4pc7+cRAGniuFwyEqLHQ+B4KC+5ZfKcNg==
X-Received: by 2002:a05:6e02:1d09:b0:35f:70e3:220c with SMTP id i9-20020a056e021d0900b0035f70e3220cmr370829ila.54.1702422400751;
        Tue, 12 Dec 2023 15:06:40 -0800 (PST)
Received: from dread.disaster.area (pa49-180-125-5.pa.nsw.optusnet.com.au. [49.180.125.5])
        by smtp.gmail.com with ESMTPSA id x12-20020a17090aa38c00b002858ac5e401sm10762985pjp.45.2023.12.12.15.06.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Dec 2023 15:06:40 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1rDBpl-007UqY-1k;
	Wed, 13 Dec 2023 10:06:37 +1100
Date: Wed, 13 Dec 2023 10:06:37 +1100
From: Dave Chinner <david@fromorbit.com>
To: NeilBrown <neilb@suse.de>
Cc: Kent Overstreet <kent.overstreet@linux.dev>,
	Donald Buczek <buczek@molgen.mpg.de>,
	linux-bcachefs@vger.kernel.org,
	Stefan Krueger <stefan.krueger@aei.mpg.de>,
	David Howells <dhowells@redhat.com>, linux-fsdevel@vger.kernel.org
Subject: Re: file handle in statx (was: Re: How to cope with subvolumes and
 snapshots on muti-user systems?)
Message-ID: <ZXjnffHOo+JY/M4b@dread.disaster.area>
References: <20231211233231.oiazgkqs7yahruuw@moria.home.lan>
 <170233878712.12910.112528191448334241@noble.neil.brown.name>
 <20231212000515.4fesfyobdlzjlwra@moria.home.lan>
 <170234279139.12910.809452786055101337@noble.neil.brown.name>
 <ZXf1WCrw4TPc5y7d@dread.disaster.area>
 <20231212152153.tasaxsrljq2zzbxe@moria.home.lan>
 <ZXjHEPn3DfgQNoms@dread.disaster.area>
 <20231212212306.tpaw7nfubbuogglw@moria.home.lan>
 <ZXjaWIFKvBRH7Q4c@dread.disaster.area>
 <170242027365.12910.2226609822336684620@noble.neil.brown.name>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <170242027365.12910.2226609822336684620@noble.neil.brown.name>

On Wed, Dec 13, 2023 at 09:31:13AM +1100, NeilBrown wrote:
> On Wed, 13 Dec 2023, Dave Chinner wrote:
> > 
> > What you are suggesting is that we now duplicate filehandle encoding
> > into every filesystem's statx() implementation.  That's a bad
> > trade-off from a maintenance, testing and consistency POV because
> > now we end up with lots of individual, filehandle encoding
> > implementations in addition to the generic filehandle
> > infrastructure that we all have to test and validate.
> 
> Not correct.  We are suggesting an interface, not an implementation.
> Here you are proposing a suboptimal implementation, pointing out its
> weakness, and suggesting the has consequences for the interface
> proposal.  Is that the strawman fallacy?

No, you simply haven't followed deep enough into the rabbit hole to
understand Kent was suggesting potential implementation details to
address hot path performance concerns with filehandle encoding.

> vfs_getattr_nosec could, after calling i_op->getattr, check if
> STATX_HANDLE is set in request_mask but not in ->result_mask.
> If so it could call exportfs_encode_fh() and handle the result.
>
> No filesystem need to be changed.

Well, yes, it's pretty damn obvious that is exactly what I've been
advocating for here - if we are going to put filehandles in statx(),
then it must use the same infrastructure as name_to_handle_at().
i.e. calling exportfs_encode_fh(EXPORT_FH_FID) to generate the
filehandle.

The important discussion detail you've missed about
exportfs_encode_fh() is that it *requires* adding a new indirect
call (via export_ops->encode_fh) in the statx path to encode the
filehandle, and that's exactly what Kent was suggesting we can code
the implementation to avoid.

Avoiding an indirect function call is an implementation detail, not
an interface design requirement.

And the only way to avoid adding new indirect calls to encoding
filesystem specific filehandles is to implement the encoding in the
existing individual filesystem i_op->getattr methods. i.e. duplicate
the filehandle encoding in the statx path rather than use
exportfs_encode_fh().....

-Dave.
-- 
Dave Chinner
david@fromorbit.com
