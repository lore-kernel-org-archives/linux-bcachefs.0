Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCC22548F7
	for <linux-bcachefs@vger.kernel.org>; Thu, 18 Jul 2024 21:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721337662; cv=none; b=BmyokDdRKFrySdGJisTtLvorqrzBUCvM2pDTeeSKYvF35I31LDIDCeZl9vM+VmaaVwmCQssP/ZBFVmvouUtK6lfTcaMFgOzrfvcLKk2Uj1+ABUw2BX8saM6+cP6GRzqAzJKYglItIxvlECGSi1D+u4exCDvSLtYkNsLKkBu0duY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721337662; c=relaxed/simple;
	bh=RZw2i8UrOi8Q1Fc2pDFx+H4J7Gb9qBN9BWgaz03JJFk=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OcTD316abK5EbL4BqIkQb4SntD9wMynOj9wJMqcMtTjuiO1SGN7kIy1RgQ75gynuC22MMtaHankYrgXlhL0mKkgEDFbBB1EFtouwDF6b6DU6AaFP7f+nKG+id9cxH+Eiwq+gmlD4yxVkgkXrKnux/QH+Py9t5FQBVVQpbHXVgHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=ZEmz38a7; arc=none smtp.client-ip=91.218.175.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="ZEmz38a7"
X-Envelope-To: torvalds@linux-foundation.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1721337657;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=aDTCIKN/tylTX5pn2P0imoeETOT7vhbtEEBcfk2BWhk=;
	b=ZEmz38a7aQrGm+FWvdowzjd00o06i3IKRy0kjwRXgcYGdd+32Mm+ZN04/hRu8gjaXE6u+w
	sW4PsUZ7anQzl6YUSaSftageS7z/vbwozYDqEtU/z3zqt2gpKYrFLyjCaToph4xxoTafpx
	YHsk7GxpqmGrz4UdbbOyawHrRFq7Bwg=
X-Envelope-To: longman@redhat.com
X-Envelope-To: linux-bcachefs@vger.kernel.org
X-Envelope-To: linux-fsdevel@vger.kernel.org
X-Envelope-To: linux-kernel@vger.kernel.org
Date: Thu, 18 Jul 2024 17:20:54 -0400
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Linus Torvalds <torvalds@linux-foundation.org>, 
	Waiman Long <longman@redhat.com>
Cc: linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [GIT PULL] bcachefs changes for 6.11
Message-ID: <5ypgzehnp2b3z2e5qfu2ezdtyk4dc4gnlvme54hm77aypl3flj@xlpjs7dbmkwu>
References: <r75jqqdjp24gikil2l26wwtxdxvqxpgfaixb2rqmuyzxnbhseq@6k34emck64hv>
 <CAHk-=wigjHuE2OPyuT6GK66BcQSAukSp0sm8vYvVJeB7+V+ecQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wigjHuE2OPyuT6GK66BcQSAukSp0sm8vYvVJeB7+V+ecQ@mail.gmail.com>
X-Migadu-Flow: FLOW_OUT

On Wed, Jul 17, 2024 at 11:53:04AM GMT, Linus Torvalds wrote:
> On Sun, 14 Jul 2024 at 18:26, Kent Overstreet <kent.overstreet@linux.dev> wrote:
> >
> > Hi Linus - another opossum for the posse:
> 
> (The kernel naming tends to be related to some random event, in this
> case we had a family of opossums under our shed for a couple of
> months)

Oh cute :)

> > bcachefs changes for 6.11-rc1
> 
> As Stephen pointed out, all of this seems to have been rebased
> basically as the merge window opened, so if it was in linux-next, I
> certainly can't easily validate it without having to compare patch ids
> etc. DON'T DO THIS.

I had to give this some thought; the proximate cause was just
fat fingering/old reflexes, but the real issue that's been causing
conflicts is that I've got testers running my trees who very much /do/
need to be on the latest tagged release.

And I can't just leave it for them to do a rebase/merge, because a) they
don't do that, and b) then I'm looking at logs with commits I can't
reference.

So - here's how my branches are going to be from now on:

As before:

- bcachefs-testing: code goes here first, until it's passed the testing
  automation. Don't run this unless you're working with me on something.
- for-next: the subset of bcachefs-testing that's believed to be stable
- bcachefs-for-upstream: queue for next pull request, generally just
  hotfixes

But my master branch (previously the same as for-next) will now be
for-next merged with the latest tag from your tree, and I may do
similarly for bcachefs-for-upstream if it's needed.

As a bonus, this means the testing automation will now be automatically
testing my branch + your latest; this would have caught the breakage
from Christoph's FUA changes back in 6.7.

> Also, the changes to outside fs/bcachefs had questions that weren't answered.

Yeah, those comments should have been added. Waiman, how's this?

-- >8 --

From 1d8cbc45ef1bab9be7119e0c5a6f8a05d5e2ca7d Mon Sep 17 00:00:00 2001
From: Kent Overstreet <kent.overstreet@linux.dev>
Date: Thu, 18 Jul 2024 17:17:10 -0400
Subject: [PATCH] lockdep: Add comments for lockdep_set_no{validate,track}_class()

Cc: Waiman Long <longman@redhat.com>
Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>

diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
index b76f1bcd2f7f..bdfbdb210fd7 100644
--- a/include/linux/lockdep.h
+++ b/include/linux/lockdep.h
@@ -178,9 +178,22 @@ static inline void lockdep_init_map(struct lockdep_map *lock, const char *name,
 			      (lock)->dep_map.wait_type_outer,		\
 			      (lock)->dep_map.lock_type)
 
+/**
+ * lockdep_set_novalidate_class: disable checking of lock ordering on a given
+ * lock
+ *
+ * Lockdep will still record that this lock has been taken, and print held
+ * instances when dumping locks
+ */
 #define lockdep_set_novalidate_class(lock) \
 	lockdep_set_class_and_name(lock, &__lockdep_no_validate__, #lock)
 
+/**
+ * lockdep_set_notrack_class: disable lockdep tracking of a given lock entirely
+ *
+ * Bigger hammer than lockdep_set_novalidate_class: so far just for bcachefs,
+ * which takes more locks than lockdep is able to track (48).
+ */
 #define lockdep_set_notrack_class(lock) \
 	lockdep_set_class_and_name(lock, &__lockdep_no_track__, #lock)
 
