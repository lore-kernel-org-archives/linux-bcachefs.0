Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C26FE6D1B4
	for <linux-bcachefs@vger.kernel.org>; Thu, 18 Jul 2024 21:48:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721339340; cv=none; b=e4RCjcr6QyiUHDMfHoywfT8hYTasPcSAdvl0IsllR4dDzhrxiIJIb8yte2wjRze3l3R5+8Rm0FVt9dfz5WS8Hh5ceK9Q3EGDglayVKd1ke6DhXe4auEWffkx6UclyO1GGTtZC1ja9HkCCSZGT1mM3DQRsG73OIa33s0krk9R2+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721339340; c=relaxed/simple;
	bh=fRDaX9VTlaeoApmfLRQ+W7qdpJvrMy/JLsVSvBohTwo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bVeY8kVRgnPg5x6YtLsa6nuyj61RDD8wOQNB2uFPahplbYG2DY47wDkSE/hIpkPOaVLcxROWkO6H4EE+oGVDEbO48jkpQeaQp3IuP5/GSvMaPaCYqp6eGo5eNoFvTAFkdSlnlBDAwOR+fXgMkx3bDElSp8q7tzG1QvQ4XE73g4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=gsRqDceO; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gsRqDceO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1721339337;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iSDJ+UGcBOwd8jwVhUDcFJXEg2LhB5hHVkSUyhvGsv4=;
	b=gsRqDceOTVGX7zG1uM4vjST2fFqC6YvZI6m/+0pJCnc0Q6tGgdZvu2jnE5X/T3M6FdGdj7
	Ilj24V+ud30uA6wtemP9JKgsTPB5T1mhuVnFI/jxmD9MQ1RQ/Zr0h4cp+3cZDv0gDwqidH
	neXvNYoDyUt0Y8Rxp73OvkdtDC9Sm4g=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-641-xZdVVzpXPYOxyTivrBnr-w-1; Thu,
 18 Jul 2024 17:48:53 -0400
X-MC-Unique: xZdVVzpXPYOxyTivrBnr-w-1
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 7C56D19560B1;
	Thu, 18 Jul 2024 21:48:52 +0000 (UTC)
Received: from [10.22.32.50] (unknown [10.22.32.50])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 2214C195605A;
	Thu, 18 Jul 2024 21:48:50 +0000 (UTC)
Message-ID: <3f4f7090-7009-4509-9122-b75a0d9ce32c@redhat.com>
Date: Thu, 18 Jul 2024 17:48:50 -0400
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] bcachefs changes for 6.11
To: Kent Overstreet <kent.overstreet@linux.dev>,
 Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-bcachefs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <r75jqqdjp24gikil2l26wwtxdxvqxpgfaixb2rqmuyzxnbhseq@6k34emck64hv>
 <CAHk-=wigjHuE2OPyuT6GK66BcQSAukSp0sm8vYvVJeB7+V+ecQ@mail.gmail.com>
 <5ypgzehnp2b3z2e5qfu2ezdtyk4dc4gnlvme54hm77aypl3flj@xlpjs7dbmkwu>
Content-Language: en-US
From: Waiman Long <longman@redhat.com>
In-Reply-To: <5ypgzehnp2b3z2e5qfu2ezdtyk4dc4gnlvme54hm77aypl3flj@xlpjs7dbmkwu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

On 7/18/24 17:20, Kent Overstreet wrote:
> On Wed, Jul 17, 2024 at 11:53:04AM GMT, Linus Torvalds wrote:
>> On Sun, 14 Jul 2024 at 18:26, Kent Overstreet <kent.overstreet@linux.dev> wrote:
>>> Hi Linus - another opossum for the posse:
>> (The kernel naming tends to be related to some random event, in this
>> case we had a family of opossums under our shed for a couple of
>> months)
> Oh cute :)
>
>>> bcachefs changes for 6.11-rc1
>> As Stephen pointed out, all of this seems to have been rebased
>> basically as the merge window opened, so if it was in linux-next, I
>> certainly can't easily validate it without having to compare patch ids
>> etc. DON'T DO THIS.
> I had to give this some thought; the proximate cause was just
> fat fingering/old reflexes, but the real issue that's been causing
> conflicts is that I've got testers running my trees who very much /do/
> need to be on the latest tagged release.
>
> And I can't just leave it for them to do a rebase/merge, because a) they
> don't do that, and b) then I'm looking at logs with commits I can't
> reference.
>
> So - here's how my branches are going to be from now on:
>
> As before:
>
> - bcachefs-testing: code goes here first, until it's passed the testing
>    automation. Don't run this unless you're working with me on something.
> - for-next: the subset of bcachefs-testing that's believed to be stable
> - bcachefs-for-upstream: queue for next pull request, generally just
>    hotfixes
>
> But my master branch (previously the same as for-next) will now be
> for-next merged with the latest tag from your tree, and I may do
> similarly for bcachefs-for-upstream if it's needed.
>
> As a bonus, this means the testing automation will now be automatically
> testing my branch + your latest; this would have caught the breakage
> from Christoph's FUA changes back in 6.7.
>
>> Also, the changes to outside fs/bcachefs had questions that weren't answered.
> Yeah, those comments should have been added. Waiman, how's this?
>
> -- >8 --
>
>  From 1d8cbc45ef1bab9be7119e0c5a6f8a05d5e2ca7d Mon Sep 17 00:00:00 2001
> From: Kent Overstreet <kent.overstreet@linux.dev>
> Date: Thu, 18 Jul 2024 17:17:10 -0400
> Subject: [PATCH] lockdep: Add comments for lockdep_set_no{validate,track}_class()
>
> Cc: Waiman Long <longman@redhat.com>
> Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>
>
> diff --git a/include/linux/lockdep.h b/include/linux/lockdep.h
> index b76f1bcd2f7f..bdfbdb210fd7 100644
> --- a/include/linux/lockdep.h
> +++ b/include/linux/lockdep.h
> @@ -178,9 +178,22 @@ static inline void lockdep_init_map(struct lockdep_map *lock, const char *name,
>   			      (lock)->dep_map.wait_type_outer,		\
>   			      (lock)->dep_map.lock_type)
>   
> +/**
> + * lockdep_set_novalidate_class: disable checking of lock ordering on a given
> + * lock
> + *
> + * Lockdep will still record that this lock has been taken, and print held
> + * instances when dumping locks
> + */
>   #define lockdep_set_novalidate_class(lock) \
>   	lockdep_set_class_and_name(lock, &__lockdep_no_validate__, #lock)
>   
> +/**
> + * lockdep_set_notrack_class: disable lockdep tracking of a given lock entirely
> + *
> + * Bigger hammer than lockdep_set_novalidate_class: so far just for bcachefs,
> + * which takes more locks than lockdep is able to track (48).
> + */
>   #define lockdep_set_notrack_class(lock) \
>   	lockdep_set_class_and_name(lock, &__lockdep_no_track__, #lock)
>   
>
That should be good enough.

Thanks,
Longman

