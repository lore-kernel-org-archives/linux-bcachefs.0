Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A8CA10F2
	for <linux-bcachefs@vger.kernel.org>; Thu, 27 Mar 2025 00:49:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743036564; cv=none; b=QkQkSrx3f2i0iwiV6CbgVgMlYe6USGAwjU928JVVX7vPTjsH7yPSpiBtvG3EWKPxjlQrkg/MqRA2JmEVGp9HXy65XXv2p5CpTAwFvh+BBvxEd5wRBy+/k6Scsw7fe/3hrHmFmUfL/Q8c4tbkfE6Ok1ReErL0ablRwXPoG/ArkII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743036564; c=relaxed/simple;
	bh=vas3lG2zNno1SckSd4WbKbyu5O+A37fZcy1pbm9gH3I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=evo0u3rVEx5cWA/RpfTS/oVnbS0fD5yVDRBmRZoSKVMYJMIhwc/eZUEyJSFwxGPTkHQm9/fiYRCU7kqXhAGUB9A8wPf1DoSQayexASdmW2/UwTCv/l1grK7mR+DoyrhTAfg+ftrayfGtM0aqoqYQZpxC9A0DIv1btzo/0oUihe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=YzxnSyKm; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="YzxnSyKm"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-227aaa82fafso9924735ad.2
        for <linux-bcachefs@vger.kernel.org>; Wed, 26 Mar 2025 17:49:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1743036562; x=1743641362; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=U3ibaiMuu+COMl2CleDE3M0U3/NtyoxWAeWllDuQocU=;
        b=YzxnSyKmdSaV1poyNBEyI6UiHNoF7ftIb+lsNYesV3skiZ3zuhYmLnWlcrDmQSXNiJ
         Nz5kxCHlJ+ptIm99W8NuZsyJRMvFa08mDNdtmxCfosrC12NW01t5QGyW5jUlBldkobrR
         Pgcajrn+HP4G5P9pLrEFQKGaBzYxiqHwiuq7lshgjn3naALa6krCuwaIH9Kgx3WIUmGf
         HbqULy03IuRQtg7t+ehBdOZ1+jeYeXTEXjw5Eh3XOcCq0ZPcs/HePUHqjRwe/utKY7nc
         ltieODn9avUyZRgp3EYFxt/zN5t10cSom5Vf7Ch5FmhaJTdAkd8mhxcFhUJtKObf09eL
         xAVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743036562; x=1743641362;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U3ibaiMuu+COMl2CleDE3M0U3/NtyoxWAeWllDuQocU=;
        b=NPGYlAiyq8a6KRDHS0Z2B1/Z4Mv5N7nduzlszm33/DHgYBdyhyCVmPZq62q+MTw8k7
         a6TdeTl2nlShLwaQdjSMkzEtzuxfMRcxe4vYPphw8cHI++GjTr3GuNFM79H8VvGjKGsI
         gqApze2Hr/gJtgEqJpefbT+T4Be8qvkar7AIL2NbgpHTrqrjUvqJ+/K3ueI0qHazWru9
         xDE2itG+JPvLT55/00OegmI445E/dLLfJzwnILcMmhPcTRTjycuWJ1JuNahKDhWCrnM6
         IK1huuns5cgVRDL3uWZLdumwEoqj7R84VsviGlhloqlr0S/PStL2AgOcC2jgpUf06Z3S
         Vd6A==
X-Forwarded-Encrypted: i=1; AJvYcCUbva5y/A98bqVrPLdXnSuv1ahBZP/eI1pLUHaVmS0jHJEFQOF5x3mJFEUtVqxs60XmXqfphFgWnlImmpThUA==@vger.kernel.org
X-Gm-Message-State: AOJu0YyWX9sMxt6K9A8jhv5l/cIZCcROQF98QsHXtTdLDit90JxAcdFF
	IAhCUfXWqwdf9MOMieG+cQzvU30sG6wquuCtFO6/1Iuc590Ob9VHXSUOz//QVnE=
X-Gm-Gg: ASbGncv6JWoScbKdB+eVKWSHnaTSPMinT0rC93VlSIWwOdEzdVqhEwV6rt0pedhyvwf
	WrNam7dUkOGA5iQHAFdJit1a36bQ7W9gDqWGdyUuR61EQZwex1ztbAevQ+LL0jX5t24xG6lFW34
	0n8YdBK4VEhby0+NhaUZhkiJcp67SAj7Mu2Mz+fAu5GT/ezYP9ujgQlj2mjdQ442gyZM2jhXpyD
	2+AaD1mhuxj1t2TsKtmRlNzmO1ktPfqM3emiFRvQDEvofzQDGL89/0Nicc6J781WhkEmFUl4LSF
	0GeXZWxoFmqHbJEQXCpaHrh9i1IcsyFdROCIuTDernlDQzIX8ibuxsPm753fzJ2/iNdtXJdd2Ol
	cA7Kcq6w=
X-Google-Smtp-Source: AGHT+IFnAErnvRw6w6zYA8RwNXoDN/pZhTmE2gfdgW366+JFnzo8IFmWZzTDFcSClOKbvjQXE59Ogg==
X-Received: by 2002:a05:6a20:2d20:b0:1f0:e42e:fb1d with SMTP id adf61e73a8af0-1fea301bd45mr3128802637.36.1743036562470;
        Wed, 26 Mar 2025 17:49:22 -0700 (PDT)
Received: from dread.disaster.area (pa49-181-60-96.pa.nsw.optusnet.com.au. [49.181.60.96])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7390611c950sm13311890b3a.104.2025.03.26.17.49.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Mar 2025 17:49:21 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1txbQt-00000000kyo-0I5r;
	Thu, 27 Mar 2025 11:49:19 +1100
Date: Thu, 27 Mar 2025 11:49:19 +1100
From: Dave Chinner <david@fromorbit.com>
To: Petr Vorel <pvorel@suse.cz>
Cc: Andrea Cervesato <andrea.cervesato@suse.de>, ltp@lists.linux.it,
	Kent Overstreet <kent.overstreet@linux.dev>,
	linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	Li Wang <liwang@redhat.com>, Cyril Hrubis <chrubis@suse.cz>
Subject: Re: [LTP] [PATCH] ioctl_ficlone03: fix capabilities on immutable
 files
Message-ID: <Z-Sgj_XOVar8myLw@dread.disaster.area>
References: <20250326-fix_ioctl_ficlone03_32bit_bcachefs-v1-1-554a0315ebf5@suse.com>
 <20250326134749.GA45449@pevik>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250326134749.GA45449@pevik>

On Wed, Mar 26, 2025 at 02:47:49PM +0100, Petr Vorel wrote:
> Hi all,
> 
> [ Cc Kent and other filesystem folks to be sure we don't hide a bug ]
> 
> > From: Andrea Cervesato <andrea.cervesato@suse.com>
> 
> > Make sure that capabilities requirements are satisfied when accessing
> > immutable files. On OpenSUSE Tumbleweed 32bit bcachefs fails with the
> > following error due to missing capabilities:
> 
> > tst_test.c:1833: TINFO: === Testing on bcachefs ===
> > ..
> > ioctl_ficlone03.c:74: TBROK: ioctl .. failed: ENOTTY (25)
> > ioctl_ficlone03.c:89: TWARN: ioctl ..  failed: ENOTTY (25)
> > ioctl_ficlone03.c:91: TWARN: ioctl ..  failed: ENOTTY (25)
> > ioctl_ficlone03.c:98: TWARN: close(-1) failed: EBADF (9)

None of these are -EPERM, so how is a missing capability that
results in -EPERM being returned cause -ENOTTY or -EBADF failures?

ohhhhh. ENOTTY is a result of a kernel side compat ioctl handling bug
w/ bcachefs.

bcachefs doesn't implement ->fileattr_set().

sys_compat_ioctl() does:

        case FS_IOC32_GETFLAGS:
        case FS_IOC32_SETFLAGS:
                cmd = (cmd == FS_IOC32_GETFLAGS) ?
                        FS_IOC_GETFLAGS : FS_IOC_SETFLAGS;

and then calls do_vfs_ioctl().

This then ends up in vfs_fileattr_set(), which does:

	if (!inode->i_op->fileattr_set)
                return -ENOIOCTLCMD;

which means sys_compat_ioctl() then falls back to calling
->compat_ioctl().

However, cmd has been overwritten to FS_IOC_SETFLAGS and
bch2_compat_fs_ioctl() looks for FS_IOC32_SETFLAGS, so it returns
-ENOIOCTLCMD as it doesn't handle the ioctl command passed in.

sys_compat_ioctl() then converts the -ENOIOCTLCMD to -ENOTTY, and
there's the error being reported.

OK, this is a bcachefs compat ioctl handling bug, triggered by not
implementing ->fileattr_set and implementing FS_IOC_SETFLAGS
directly itself via ->unlocked_ioctl.

Yeah, fixes to bcachefs needed here, not LTP.

> I wonder why it does not fail for generic VFS fs/ioctl.c used by Btrfs and XFS:

Because they implement ->fileattr_set() and so all the compat ioctl
FS_IOC32_SETFLAGS handling works as expected.

-Dave.
-- 
Dave Chinner
david@fromorbit.com
