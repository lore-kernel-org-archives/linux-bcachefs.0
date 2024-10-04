Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5826A1849
	for <linux-bcachefs@vger.kernel.org>; Fri,  4 Oct 2024 00:46:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728002793; cv=none; b=LSrjWKiKetUTUAcOKQIz88MTe2ObO8erqToV889XMjJ4BhchT0cSj4+n8FUsStNpUsaQZcoYu+oegAQqlWNI9GlmK6Umu1dL68aibpVoHZD0eBSBxs/aZOUiHKAWTdl6CgAIvioc2L9TYEcXYYTRwH6RuahDq1di+mWR8ZCnHN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728002793; c=relaxed/simple;
	bh=Gd8MWtiHNW0MP5r1VtRnLKSyPvxQq14CoCngTLSmOdI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=JsIbj7+DpJ86mpu27D9lffmh4UCiQwpfTYy0+fzDH2row/Lrx/n3PwsCcV5kQd6nxo+VhaPjfj7zZglYlEuW8H6HUlTlNCe3gnLKrYyEHUV+V0NAUuJ5I8gjrVyd9jwtcQzXl4/EXlfwZCa+F2k9G4L2+bMZQEed/m0uU+DJxeo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=M8+tPrBw; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="M8+tPrBw"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-207115e3056so14310835ad.2
        for <linux-bcachefs@vger.kernel.org>; Thu, 03 Oct 2024 17:46:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1728002792; x=1728607592; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=5oL7aA9ZouY5ZFpXF1+6PljZFIX5q9qbYeaK5yp3f5o=;
        b=M8+tPrBwYIbphBh7sXBhSafwnM3UJX4rDEmRugHziIwF4Tpyc1ODaKoHunejPU8JzC
         7KAC4DPp1NnsZ8wtyct3AagloaNoKMOAoo5iUaN7q0PIazO5JJKWG0VN/E5xJYs24lui
         ztgvePCmTvzmOWeVX807LHuGY84DuhDSHQ/ypEiGjPMba6VJdjEg7TxsO58Gx5XCabpE
         MVQrkz+dX0DlWWQUoxT2mbjqqzgv57rR5M+w645KsK9V4+Y37n1kLXGRqxSRUEbBF3H5
         p93N41+ivMvv6NJEKsA8S4ZhjJMzWmqqLSbxSDF8GeC+blgPM7G+aePkT9VcIZO7jBxC
         pKGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728002792; x=1728607592;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5oL7aA9ZouY5ZFpXF1+6PljZFIX5q9qbYeaK5yp3f5o=;
        b=THhycHOyu0V//VwRIt3G2e0BySzlnNI5/dLY0Ql6ckA/VWngM7baqHavdhV4maiPS4
         of6uHkkV5bCCGZqbJGUWOdP2gCvujCtGXSP9BvkHwtZI6MhvzS7ADip8FJpLU2vNovjv
         IIuVeAUoVQa9VdX0sY5EdIMCGsu5+ZWxd1RFYIOrhEQni4NsUIV2ZNWHuXfjak5qy1pK
         n82X9IKWVj0RK5ryvLhztw9lnJQaUom4+CnzZqpiySXFt6npPogBIYxGSSOjPiOmlcni
         mpgmrlrgteMqf5LGVjcSKY2ylyCmD0tMTDhJLTOIuOwORxZ01aieukj24p+Q4IbD8RvM
         yMVQ==
X-Forwarded-Encrypted: i=1; AJvYcCXXUQtVs6IMsQaPqWM01lp2B3Pc/X/fL70vxTnj5FMxJM8A/ICoZHEjeVtqicLTExFReh+tR5ouWZ4wIAlwng==@vger.kernel.org
X-Gm-Message-State: AOJu0Yy92TR1IMWSwV+KbKFQmIALruz3UPp3AiyuZm3m6OqdLZfOapDY
	6Bv2sXdm1hR0LHDfw7wbUm16IpGOijWcXAUzkD2DP1ifSVD3h4KYjOpAMcUwe7M=
X-Google-Smtp-Source: AGHT+IGYTOOZ0nv/cNl+WLKR+qQb6xrz41gIx2II56JGm8tfocsfbkKKQHENHQ+D1/d4e6k46fplVQ==
X-Received: by 2002:a17:903:2443:b0:20b:61c0:43ed with SMTP id d9443c01a7336-20bfe181244mr12642925ad.30.1728002791570;
        Thu, 03 Oct 2024 17:46:31 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-78-197.pa.nsw.optusnet.com.au. [49.179.78.197])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-20beeca1989sm14559075ad.118.2024.10.03.17.46.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Oct 2024 17:46:30 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1swWSh-00Dbsy-2p;
	Fri, 04 Oct 2024 10:46:27 +1000
Date: Fri, 4 Oct 2024 10:46:27 +1000
From: Dave Chinner <david@fromorbit.com>
To: Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
	linux-xfs@vger.kernel.org, linux-bcachefs@vger.kernel.org,
	kent.overstreet@linux.dev, torvalds@linux-foundation.org,
	=?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@linux.microsoft.com>,
	Jann Horn <jannh@google.com>, Serge Hallyn <serge@hallyn.com>,
	Kees Cook <keescook@chromium.org>,
	linux-security-module@vger.kernel.org,
	Amir Goldstein <amir73il@gmail.com>
Subject: Re: lsm sb_delete hook, was Re: [PATCH 4/7] vfs: Convert
 sb->s_inodes iteration to super_iter_inodes()
Message-ID: <Zv8648YMT10TMXSL@dread.disaster.area>
References: <20241002014017.3801899-5-david@fromorbit.com>
 <Zv5GfY1WS_aaczZM@infradead.org>
 <Zv5J3VTGqdjUAu1J@infradead.org>
 <20241003115721.kg2caqgj2xxinnth@quack3>
 <Zv6J34fwj3vNOrIH@infradead.org>
 <20241003122657.mrqwyc5tzeggrzbt@quack3>
 <Zv6Qe-9O44g6qnSu@infradead.org>
 <20241003125650.jtkqezmtnzfoysb2@quack3>
 <Zv6jV40xKIJYuePA@dread.disaster.area>
 <20241003161731.kwveypqzu4bivesv@quack3>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241003161731.kwveypqzu4bivesv@quack3>

On Thu, Oct 03, 2024 at 06:17:31PM +0200, Jan Kara wrote:
> On Thu 03-10-24 23:59:51, Dave Chinner wrote:
> > As for the landlock code, I think it needs to have it's own internal
> > tracking mechanism and not search the sb inode list for inodes that
> > it holds references to. LSM cleanup should be run before before we
> > get to tearing down the inode cache, not after....
> 
> Well, I think LSM cleanup could in principle be handled together with the
> fsnotify cleanup but I didn't check the details.

I'm not sure how we tell if an inode potentially has a LSM related
reference hanging off it. The landlock code looks to make an
assumption in that the only referenced inodes it sees will have a
valid inode->i_security pointer if landlock is enabled. i.e. it
calls landlock_inode(inode) and dereferences the returned value
without ever checking if inode->i_security is NULL or not.

I mean, we could do a check for inode->i_security when the refcount
is elevated and replace the security_sb_delete hook with an
security_evict_inode hook similar to the proposed fsnotify eviction
from evict_inodes().

But screwing with LSM instructure looks ....  obnoxiously complex
from the outside...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
