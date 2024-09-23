Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAA538F5B
	for <linux-bcachefs@vger.kernel.org>; Mon, 23 Sep 2024 03:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727063966; cv=none; b=lGa3lS+1XswCQjgIFKv3FzM7Q6EgIeFIAkjKj2/15tzxr7nuB4fLhVTxwe2dm0DjdmqxkARLvUCX6DCQWnzId/4JmGMioD7GiRtwv+ojj9dJI9b5Ux0x9gzlvvzhrnX+FHskyipVhsyr+R5R2+MrtxhrF+QI+4wwG7IBxaCuYvM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727063966; c=relaxed/simple;
	bh=GXqbuvfD/rW69uVJfm3/S/Sh5AEDddUKxAmTK2Msp4k=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IbemVvjF9xi5UE/29aCcIxByOn4eb7pxOkEGd0iZkt7QgWbD8j+oq4iG6d6ICHjNC2bbJbN9vzDxhRVPB2ZFsszglE6X4nRfUBQrQkxTmarul6KxZc4T3Zc8zN8uJv6Fz1Mhq6YlikDeB+pol8WtQIMYb34hKSLxqyYS0B8fLeQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=KhwgFh+P; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=yGAaCswf; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=KhwgFh+P; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=yGAaCswf; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="KhwgFh+P";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="yGAaCswf";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="KhwgFh+P";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="yGAaCswf"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id C20F41FB67;
	Mon, 23 Sep 2024 03:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1727063961; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fu0sykezGgs6lRtnOD+0scY9OpD1hUHYd7s5mMJh2uY=;
	b=KhwgFh+P74jXvgPitdVKQq9XqWT9p6I07JhBkjNQWQElW7mpvCGuAxgz0UDuHbJl/AGc/D
	iK2pIzSs5E0HrDoPiwjkr0x0iDSghaX4cnWjExYsbcavaP/YidXRodq1vbbgmeAg5k9VJJ
	x0sz+tcMwNrvjkUoOi3QQlNJ0MPzEmQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1727063961;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fu0sykezGgs6lRtnOD+0scY9OpD1hUHYd7s5mMJh2uY=;
	b=yGAaCswfNUlw4F8F23ARtp/O7oUhiUDiTqONgrSH5ipTFz6Sjpeom4YLw6mGVMUkIUCaW+
	Uxb7moTEJqLuYxDw==
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1727063961; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fu0sykezGgs6lRtnOD+0scY9OpD1hUHYd7s5mMJh2uY=;
	b=KhwgFh+P74jXvgPitdVKQq9XqWT9p6I07JhBkjNQWQElW7mpvCGuAxgz0UDuHbJl/AGc/D
	iK2pIzSs5E0HrDoPiwjkr0x0iDSghaX4cnWjExYsbcavaP/YidXRodq1vbbgmeAg5k9VJJ
	x0sz+tcMwNrvjkUoOi3QQlNJ0MPzEmQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1727063961;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fu0sykezGgs6lRtnOD+0scY9OpD1hUHYd7s5mMJh2uY=;
	b=yGAaCswfNUlw4F8F23ARtp/O7oUhiUDiTqONgrSH5ipTFz6Sjpeom4YLw6mGVMUkIUCaW+
	Uxb7moTEJqLuYxDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D10DC132C7;
	Mon, 23 Sep 2024 03:59:19 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id tfW+H5fn8GbdJwAAD6G6ig
	(envelope-from <ddiss@suse.de>); Mon, 23 Sep 2024 03:59:19 +0000
Date: Mon, 23 Sep 2024 03:59:03 +0000
From: David Disseldorp <ddiss@suse.de>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, Martin Doucha <martin.doucha@suse.com>,
 Hongbo Li <lihongbo22@huawei.com>
Subject: Re: [PATCH resend v2] bcachefs: reject unknown mount options
Message-ID: <20240923035903.32589261.ddiss@suse.de>
In-Reply-To: <fiwda3johielxusg2ab73km7xo6f3skobw7c7rv3mc4g6epgtf@vo5urbm7nb6a>
References: <20240917013957.13353-1-ddiss@suse.de>
	<fiwda3johielxusg2ab73km7xo6f3skobw7c7rv3mc4g6epgtf@vo5urbm7nb6a>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Score: -3.30
X-Spamd-Result: default: False [-3.30 / 50.00];
	BAYES_HAM(-3.00)[99.99%];
	MID_CONTAINS_FROM(1.00)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_THREE(0.00)[4];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Level: 

On Sat, 21 Sep 2024 19:13:31 -0400, Kent Overstreet wrote:

> I applied this and got some new failures in the CI - it seems something
> is broken in remount.
...
> 00163 bcachefs: bch2_parse_one_mount_opt() Bad mount option rwerrors
> 00163 Error: Invalid argument
> 00163 Error 1 at /host//home/testdashboard/ktest/tests/fs/bcachefs/ec.ktest 32 from: mount -o remount,ro /mnt, exiting
> 00163 Error 1 at /host/home/testdashboard/ktest/tests/prelude.sh 269 from: ( set -e; run_test $i ), exiting
> 00163 
> 00163 ========= FAILED ec_small in 2s
> 
> The test is just doing
> mount -o remount,ro /mnt
> 
> Thomas, this is likely something you introduced, think you could take a
> look?

Thanks for the details. "mount -o remount,ro <mnt>" works fine for me,
and I'm not aware of anything that could be providing the "rwerrors"
parameter. Which version of mount / util-linux is used here?
