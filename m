Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C01522080DF
	for <linux-bcachefs@vger.kernel.org>; Tue, 14 Jan 2025 21:21:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736889670; cv=none; b=p0XOEjAqlOjexFZyeMBOc7+zuXzp3iSVet9IdPMTX0Zgu65Lx8MBAaW695lwqK/+7jkDyeUvjKC4ItN2eywkkfHigC95n6gCTo9LULp7EYwfHG/E7in4FjGyhKvv6qsQxQTJ3ffeYysZE3izwDWU03UEnOkLlt+3mAPuwFkFxoA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736889670; c=relaxed/simple;
	bh=geZMPf3EMsskdd3cyUHPcdZvsBGPpn/1HacLb6le9Xg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CLp4VqaivUMv+nSJEjwI2hTn7isedL6MeQvg+IiW+9l4ccdc4uduYloRbXODtcuAMa7YZvq3QO7RidaVaaK3gYb4i97wxsxap+PzM4QGijGHouqCSiWHuLv2tnUtn172eiwdNUSVukkt1hsaJjLee0cWPO+pxp7qMOflp9sVOpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com; spf=pass smtp.mailfrom=fromorbit.com; dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b=N3akVTZZ; arc=none smtp.client-ip=209.85.214.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fromorbit.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fromorbit-com.20230601.gappssmtp.com header.i=@fromorbit-com.20230601.gappssmtp.com header.b="N3akVTZZ"
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-21675fd60feso132727915ad.2
        for <linux-bcachefs@vger.kernel.org>; Tue, 14 Jan 2025 13:21:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=fromorbit-com.20230601.gappssmtp.com; s=20230601; t=1736889668; x=1737494468; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=w1pyBhR9znuGzFO9Qovl/xhPcK2onHnq0DJMNO0ivAM=;
        b=N3akVTZZRb9Bni2TZVM63ySfGit0UHg1BJ0tBa63m9c8gkU1k8ZCTH7NFI5eLbgp3n
         iDuK2WG5DCQ94Zrbpf78CyyjqcWYygORWQ7e2La50Y0CyNSbA5pf+2lWWxGNcY7Frl+H
         mEr8cCpP+ewfK/upXhZvPgLfP3AMwTH3lXmZXcPX8AeWFMwv9PYdbGrm21hvGgspi/g7
         D6SNOD+kIPFMj9DaqpR7kB9+8pUjW3KWAUz4Rsqazf/GkR9K/uFbAVoOouhlQNV0xnHq
         dYhNTZYz+LtAIU6cIjzQZMLrNl0Lt3LvY8VTo415+DAbr6bJ6blFN3XVW2t2KK7tQj4F
         GTNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736889668; x=1737494468;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w1pyBhR9znuGzFO9Qovl/xhPcK2onHnq0DJMNO0ivAM=;
        b=ROkjOG6H3Ls8UcOI7XttacdmZkqyYsQcnzgoNV8oCcP0X1xVEPeYES3HaGJIqZ+NXu
         zQnbfWbAokXgX6VpWev2GXPRhUnth27SDlMvLat8hAP6morY0a+ukEe/LjMBbrE1SWf1
         ioU8VYJwK+Vl+TRSDB7m2zg//jrZDLqAIbSYArMvR3WF7AIXj8KlJ6Ln0b2UpbCR9XL5
         RhK87pJCNkGw6F39D+DKm/XRq2K4RQJVNXMyYr+3ygxt6aWFE+9AvP6qRWhARGLzs6cw
         vK4hh0lz9pFs2SrU0foDQ1MfBstYlnpw+zpp9LTcdEMLuy4LRse8/GX/B9OqOruC3muw
         011g==
X-Forwarded-Encrypted: i=1; AJvYcCXlfsav7bYmuAUH+Y3iWEGkT1r4Z68jXJ9FbYiaTPa0WRGnxJoT4dZ97IY6PKHVojkf1IgMkHu2GcmJiwmRSQ==@vger.kernel.org
X-Gm-Message-State: AOJu0YzlxiqQOqFWB19DU3jrLMiOKeO9jYhjBmPgljsh+NJD9HHjCsWt
	mKk+jNYY4Myyq8mp1vaNgeT8VXe8xf/lUIFHBpBLh1hF6fjO2g2F/IL/2Lug4l0=
X-Gm-Gg: ASbGncue/lSxOzbEXvGYIYqnjJIyqaiMMkkI5MlPV2uNpd0+avFGzT07jtUFngiQ5WX
	MVtq4igIpQXUTA0/oTVA+qszOVhnU2aa4Ybonz7yiU70aUSD75u7tZfgHk72qi2PpbXox6cgyiH
	wifPIIJ9Gbt+i92JF2l3usyzBbGHXeB4tpD5+dZC69nMlf5tD0PCH3vuKXk2+2tVG9zWWl/kSe2
	IG44mR/UiKnuHWmRk6CYUwGSjiqPLFIWVxfgiGbr8n5MuuR0OLrJUT4J7zKphruM02t427M0v6b
	OSZHtc7FMLlNkJnpMKGDVB7mmH7v3rjz
X-Google-Smtp-Source: AGHT+IFAEIY+uGPmg9CHflAkEgVw5JE7m1dvKQ7GkwQsD7Ae1ubXIu6SNCZEm0IafLNQtTSFVDtyxQ==
X-Received: by 2002:a05:6a20:6a24:b0:1e0:cadd:f670 with SMTP id adf61e73a8af0-1e88d13b51emr37995328637.5.1736889668086;
        Tue, 14 Jan 2025 13:21:08 -0800 (PST)
Received: from dread.disaster.area (pa49-186-89-135.pa.vic.optusnet.com.au. [49.186.89.135])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-a31ddf6ee7csm8703329a12.71.2025.01.14.13.21.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jan 2025 13:21:07 -0800 (PST)
Received: from dave by dread.disaster.area with local (Exim 4.98)
	(envelope-from <david@fromorbit.com>)
	id 1tXoLQ-00000005uTP-32bG;
	Wed, 15 Jan 2025 08:21:04 +1100
Date: Wed, 15 Jan 2025 08:21:04 +1100
From: Dave Chinner <david@fromorbit.com>
To: Theodore Ts'o <tytso@mit.edu>
Cc: Dmitry Vyukov <dvyukov@google.com>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Jan Kara <jack@suse.cz>, Kun Hu <huk23@m.fudan.edu.cn>,
	jlayton@redhat.com, adilger.kernel@dilger.ca, bfields@redhat.com,
	viro@zeniv.linux.org.uk, christian.brauner@ubuntu.com, hch@lst.de,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	brauner@kernel.org, linux-bcachefs@vger.kernel.org,
	syzkaller@googlegroups.com
Subject: Re: Bug: INFO_ task hung in lock_two_nondirectories
Message-ID: <Z4bVQEKdj4ouAGI4@dread.disaster.area>
References: <42BD15B5-3C6C-437E-BF52-E22E6F200513@m.fudan.edu.cn>
 <gwgec4tknjmjel4e37myyichugheuba3sy7cxkdqqj2raaglf5@n7uttxolimpa>
 <ftg6ukiq5secljpfloximhor2mjvda7qssydeqky4zcv4dpxxw@jadua4pcalva>
 <CACT4Y+ZtHUhXpETW+x8FpNbvN=xtKGZ1sBUQDr3TtKM+=7-xcg@mail.gmail.com>
 <20250114135751.GB1997324@mit.edu>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250114135751.GB1997324@mit.edu>

On Tue, Jan 14, 2025 at 08:57:51AM -0500, Theodore Ts'o wrote:
> P.S.  If you want to push back on this nonsense, Usenix program
> committee chairs are very much looking for open source professionals
> to participate on the program committees for Usenix ATC (Annual
> Technical Conference) and FAST (File System and Storage Technologies)
> conference.

The problem is that the Usenix/FAST paper committees will not reach
out to OSS subject matter experts to review papers that they have
been asked to review for the conference.

Let me give you a recent example of a clear failure of the FAST
paper committee w.r.t. plagarism.

The core of this paper from FAST 2022:

https://www.usenix.org/conference/fast22/presentation/kim-dohyun

"ScaleXFS: Getting scalability of XFS back on the ring"

is based on the per-CPU CIL logging work I prototyped and posted an
RFC for early in 2021:

https://lore.kernel.org/linux-xfs/20200512092811.1846252-1-david@fromorbit.com/

The main core of the improvements described in the ScaleXFS paper
are the exact per-cpu CIL algorithm in that was contained in the
above RFC patchset.

That algorithm had serious problems that meant it was unworkable in
practice - these didn't show up until journal recovery was tested
and it resulted in random filesystem corruptions. I didn't
understand the root cause of the problem until months later.

These problems were all based on failures to correctly order the
per-CPU log items in the journal due to the per-CPU CIL being
inherently racy.  The algorithm I proposed 6 months later (and
eventually got merged in July 2022) had significant changes to the
way the per-CPU CIL ordered operations to address these problems.

IOWs, object ordering on the CIL is the single most important
critical correctness citeria for the entire journalling algorithm
and hence a fundamental algorithmic constraint for the per-CPU CIL
implementation.

However, the ScaleXFS paper does not make any mention of this
fundamental algorithmic constraint - I did not publish anything
about this constraint until the November 2022 patch set....

There were more clear tell-tales in the paper that indicate
that the "research" was based on that early per-CPU CIL RFC I
posted, but I won't go into details.

I brought this to the FAST committee almost immediately after I was
able to review the paper (a couple of days after the FAST conference
itself). I provided them with all the links to public postings of
the algorithm, detailed analysis of the paper and publicly posted
code, etc. In response, they basically did nothing and brushed my
concerns off. It would take weeks to get any response from the paper
committee, and the overall response really felt like the Usenix
people simply didn't care at all about what was obviously plagarised
work.

IOWs, the Usenix/FAST peer review process for OSS related papers is
broken, and they don't seem to care when experts from the OSS
community actually bring clear cases of academic malpractice to
them...

-Dave.
-- 
Dave Chinner
david@fromorbit.com
