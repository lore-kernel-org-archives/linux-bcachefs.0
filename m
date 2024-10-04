Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 787E514AD24
	for <linux-bcachefs@vger.kernel.org>; Fri,  4 Oct 2024 22:57:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728082658; cv=none; b=bo4fdnYbUvj2u1MK3qmfwkhlHs73ixaq2NlTsZgSfFuHl2VpYsMe8Vktf/FLItjf2H+o3rCeeICs9M6xKY1qn9F+29Dxgofa0nw15RTVh/6yWZ0SDXJQRN79WVzYQ3OoJa3jLomGtM4RhC1pL46LUAE3k21yOAYr+ntBE+S57Eg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728082658; c=relaxed/simple;
	bh=0zNDYmKicdXkXJNZhkX3ch5ApN8NZLXNlezQ5lzQZXk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BGXN4Qeh/ZDWpbmNU3ltyxZz9b2rNwgyG8FMEvjyZkx1lTz8HoGvWOiU7WOyT6EVScvJ6bHtrNCcR64IqDpNO2Q/Xdjt3gmlRXE/97poI5jQGqK5LnEmUQS8XNq62Hm/f1Kqyu9/hOrkgo8yIojGR71F/RdRCPhs3GzPlwW01aY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=mYTaHYnA; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="mYTaHYnA"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-71de9e1f431so932221b3a.3
        for <linux-bcachefs@vger.kernel.org>; Fri, 04 Oct 2024 15:57:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1728082657; x=1728687457; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9ciJ8IpZWFg047k9vJRJ/wYonk/gs8Fo22fg9xIOeVY=;
        b=mYTaHYnAk5mq6ghe8XRyNhk/lkdX2LV46rV16iHHNMXCiK/wgPUEu5bgaJhybvk0wV
         Ot/+RsQmC7oKttdkgeUIXTO6wfWJqPzSQqWrZtGLWuGvjmlQA9t2vYXL7jO3BnJeNfB9
         ORdJjV7QGrGeaCkYaWg4wwezhtZzfn5XXVg0BLjpuwF22bXKJeCg2x8f4F3Jfxtytmd+
         z7oWzeAV9r58HQr0av7JTEpZH6OGBuIFjLKxpdm6UENY+nxj4liSDV+H32WNZ3jbRBQc
         vrl4a+Hfgb86MrVfmGiei0ruBAEQ65bHgBGlIGWznO/HL6cl+DnW4bWSmrDnF6XEl7On
         e3Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728082657; x=1728687457;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9ciJ8IpZWFg047k9vJRJ/wYonk/gs8Fo22fg9xIOeVY=;
        b=O+i07qHZ9V1fpRn5BFAHby8a1esZQ8+QMSe8UNu7eH6ilfjolDySD0p1atQWbMMATq
         U8JLNDnIUNQlk3NSbUjby95kKgc+UtGOY1IsjXpvLG3LeA+phKg+SgLgxIvg7tHxZ1ap
         81s5TbI21vKmj2FeDfDRzU+km1kPwGskatreyuOznQYZBHd2fQeaUnQAftsTc9U/o7bK
         4cOe7tcqfcY/TBQBsLEFJ2RH1r/B8O7ddWlbi0NUaNRv504g+cH8/TrLW44URAwreSiO
         onA5rpVNxzQrVfj7iynpHbwhMXgPsKUs5+MM73QRUn2UQs0RyynKpeYmqTa3y9oSCORV
         EiDQ==
X-Forwarded-Encrypted: i=1; AJvYcCVRa/NS5buV5hsvZbSzLNr6+Au19LIK/hPwR20UgC5IMDkjaRbjGr09x6lRza1s7xPET5cc5+8+9caqX/IS3w==@vger.kernel.org
X-Gm-Message-State: AOJu0YxR212pKimRN1Eqh8Rj8tt2Wt31q2MDmWjsBRDFVMBfkbmWYTpt
	x82O9NbWED4twrE8SgZbOInuw5Hbm3Iv6yNTb9H+z54I8nXgpy/L6DG0ffQREY0=
X-Google-Smtp-Source: AGHT+IGPlzugUs+ABOyd+HnqWXf/5t5CdbOUkyvMvvTCJY+6pBbJsYtT/6RKnJaNwbNyrnt128F94w==
X-Received: by 2002:a05:6a00:8a03:b0:71d:ee1b:c854 with SMTP id d2e1a72fcca58-71dee1bcacamr2545565b3a.9.1728082656701;
        Fri, 04 Oct 2024 15:57:36 -0700 (PDT)
Received: from dread.disaster.area (pa49-179-78-197.pa.nsw.optusnet.com.au. [49.179.78.197])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-71df0d62400sm391612b3a.152.2024.10.04.15.57.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 04 Oct 2024 15:57:36 -0700 (PDT)
Received: from dave by dread.disaster.area with local (Exim 4.96)
	(envelope-from <david@fromorbit.com>)
	id 1swrEq-00E1Jj-0h;
	Sat, 05 Oct 2024 08:57:32 +1000
Date: Sat, 5 Oct 2024 08:57:32 +1000
From: Dave Chinner <david@fromorbit.com>
To: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>, Christoph Hellwig <hch@infradead.org>,
	linux-fsdevel@vger.kernel.org, linux-xfs@vger.kernel.org,
	linux-bcachefs@vger.kernel.org, kent.overstreet@linux.dev,
	torvalds@linux-foundation.org,
	=?iso-8859-1?Q?Micka=EBl_Sala=FCn?= <mic@linux.microsoft.com>,
	Jann Horn <jannh@google.com>, Serge Hallyn <serge@hallyn.com>,
	Kees Cook <keescook@chromium.org>,
	linux-security-module@vger.kernel.org,
	Amir Goldstein <amir73il@gmail.com>
Subject: Re: lsm sb_delete hook, was Re: [PATCH 4/7] vfs: Convert
 sb->s_inodes iteration to super_iter_inodes()
Message-ID: <ZwBy3H/nR626eXSL@dread.disaster.area>
References: <Zv5J3VTGqdjUAu1J@infradead.org>
 <20241003115721.kg2caqgj2xxinnth@quack3>
 <Zv6J34fwj3vNOrIH@infradead.org>
 <20241003122657.mrqwyc5tzeggrzbt@quack3>
 <Zv6Qe-9O44g6qnSu@infradead.org>
 <20241003125650.jtkqezmtnzfoysb2@quack3>
 <Zv6jV40xKIJYuePA@dread.disaster.area>
 <20241003161731.kwveypqzu4bivesv@quack3>
 <Zv8648YMT10TMXSL@dread.disaster.area>
 <20241004-abgemacht-amortisieren-9d54cca35cab@brauner>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241004-abgemacht-amortisieren-9d54cca35cab@brauner>

On Fri, Oct 04, 2024 at 09:21:19AM +0200, Christian Brauner wrote:
> On Fri, Oct 04, 2024 at 10:46:27AM GMT, Dave Chinner wrote:
> > On Thu, Oct 03, 2024 at 06:17:31PM +0200, Jan Kara wrote:
> > > On Thu 03-10-24 23:59:51, Dave Chinner wrote:
> > > > As for the landlock code, I think it needs to have it's own internal
> > > > tracking mechanism and not search the sb inode list for inodes that
> > > > it holds references to. LSM cleanup should be run before before we
> > > > get to tearing down the inode cache, not after....
> > > 
> > > Well, I think LSM cleanup could in principle be handled together with the
> > > fsnotify cleanup but I didn't check the details.
> > 
> > I'm not sure how we tell if an inode potentially has a LSM related
> > reference hanging off it. The landlock code looks to make an
> > assumption in that the only referenced inodes it sees will have a
> > valid inode->i_security pointer if landlock is enabled. i.e. it
> > calls landlock_inode(inode) and dereferences the returned value
> > without ever checking if inode->i_security is NULL or not.
> > 
> > I mean, we could do a check for inode->i_security when the refcount
> > is elevated and replace the security_sb_delete hook with an
> > security_evict_inode hook similar to the proposed fsnotify eviction
> > from evict_inodes().
> > 
> > But screwing with LSM instructure looks ....  obnoxiously complex
> > from the outside...
> 
> Imho, please just focus on the immediate feedback and ignore all the
> extra bells and whistles that we could or should do. I prefer all of
> that to be done after this series lands.

Actually, it's not as bad as I thought it was going to be. I've
already moved both fsnotify and LSM inode eviction to
evict_inodes() as preparatory patches...

Dave Chinner (2):
      vfs: move fsnotify inode eviction to evict_inodes()
      vfs, lsm: rework lsm inode eviction at unmount

 fs/inode.c                    |  52 +++++++++++++---
 fs/notify/fsnotify.c          |  60 -------------------
 fs/super.c                    |   8 +--
 include/linux/lsm_hook_defs.h |   2 +-
 include/linux/security.h      |   2 +-
 security/landlock/fs.c        | 134 ++++++++++--------------------------------
 security/security.c           |  31 ++++++----
7 files changed, 99 insertions(+), 190 deletions(-)

-Dave.
-- 
Dave Chinner
david@fromorbit.com
