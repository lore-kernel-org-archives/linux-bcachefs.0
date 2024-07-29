Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E06331E489
	for <linux-bcachefs@vger.kernel.org>; Mon, 29 Jul 2024 11:53:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722254027; cv=none; b=N1S1VbiKnTvD+zsrwuK8yLJH+AS9Zh/EgFDtO07eriW6g5Hz4j7BCJY8R8GNDpuBc+TahGuhk3frXX2C7p/ofE4Lg1SnitAbPQxrgdVprFP0bUIjAQusAqkuPONj9YFWSi5SWA2TOFN58q+MyYmZUkXlM4+Ia9mb+OmIMBpFMAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722254027; c=relaxed/simple;
	bh=Y8DIbUraKoClAx4NSeSz1Ixn6mYPUc7MmPw43MLn+Ko=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=F+4laJCVKIW1ETac03tEqnw2DGncHeKqVanaF8LugyLX/wsvPdH1F7XFE5cTvmu9IAZM6vnPmngJvgng2J+tNOX2M9cOF9whWs4m+wvfNP55xvJ31Gs5vyhYUh2JPOTyVPquDBHLbWxsQc1Uv9SxWqcKWF1O41sCeRkaIJvuVME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=TidKj90r; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=1wzAQu6z; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=TidKj90r; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=1wzAQu6z; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="TidKj90r";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="1wzAQu6z";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="TidKj90r";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="1wzAQu6z"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0A75A1F793;
	Mon, 29 Jul 2024 11:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1722254024;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Y8DIbUraKoClAx4NSeSz1Ixn6mYPUc7MmPw43MLn+Ko=;
	b=TidKj90rA8kkeUQd3zKQIf6QlouDBGJo/eyMkZm6lczKsbmRU33N256bJdc17GLtOl+ufS
	onl3SLOxfhzomnkX50stZ6cAT+qDj1z4uhIsYP8dfHLSx2xmQ2zVc7E6l9a1yVpJiL2v7F
	H7cp1ZhYtBuN3VUciCYWtdhz11qsb2Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1722254024;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Y8DIbUraKoClAx4NSeSz1Ixn6mYPUc7MmPw43MLn+Ko=;
	b=1wzAQu6zezT3ycMO0a0YI2Vaj1tKB6YG5NFKotKVDv0bZvQ6LufRBFMuYnGj5gJ/VqRyvP
	ZnbMhjvxeOeZ5JAQ==
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=TidKj90r;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=1wzAQu6z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1722254024;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Y8DIbUraKoClAx4NSeSz1Ixn6mYPUc7MmPw43MLn+Ko=;
	b=TidKj90rA8kkeUQd3zKQIf6QlouDBGJo/eyMkZm6lczKsbmRU33N256bJdc17GLtOl+ufS
	onl3SLOxfhzomnkX50stZ6cAT+qDj1z4uhIsYP8dfHLSx2xmQ2zVc7E6l9a1yVpJiL2v7F
	H7cp1ZhYtBuN3VUciCYWtdhz11qsb2Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1722254024;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Y8DIbUraKoClAx4NSeSz1Ixn6mYPUc7MmPw43MLn+Ko=;
	b=1wzAQu6zezT3ycMO0a0YI2Vaj1tKB6YG5NFKotKVDv0bZvQ6LufRBFMuYnGj5gJ/VqRyvP
	ZnbMhjvxeOeZ5JAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D6EAC138A7;
	Mon, 29 Jul 2024 11:53:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id zljEMseCp2apOAAAD6G6ig
	(envelope-from <pvorel@suse.cz>); Mon, 29 Jul 2024 11:53:43 +0000
Date: Mon, 29 Jul 2024 13:53:35 +0200
From: Petr Vorel <pvorel@suse.cz>
To: Andrea Cervesato <andrea.cervesato@suse.de>
Cc: ltp@lists.linux.it, linux-bcachefs@vger.kernel.org,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Cyril Hrubis <chrubis@suse.cz>
Subject: Re: [LTP] [PATCH v2 3/7] Add ioctl_ficlone02 test
Message-ID: <20240729115335.GA1251624@pevik>
Reply-To: Petr Vorel <pvorel@suse.cz>
References: <20240723-ioctl_ficlone-v2-0-33075bbc117f@suse.com>
 <20240723-ioctl_ficlone-v2-3-33075bbc117f@suse.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240723-ioctl_ficlone-v2-3-33075bbc117f@suse.com>
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 0A75A1F793
X-Spam-Score: -3.51
X-Spam-Level: 
X-Spam-Flag: NO
X-Spamd-Result: default: False [-3.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	HAS_REPLYTO(0.30)[pvorel@suse.cz];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	TO_DN_SOME(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.cz:replyto,suse.cz:dkim];
	RCVD_TLS_ALL(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_FIVE(0.00)[5];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	DKIM_TRACE(0.00)[suse.cz:+];
	MISSING_XM_UA(0.00)[];
	REPLYTO_EQ_FROM(0.00)[]

Hi all,

> This test verifies that ioctl() FICLONE/FICLONERANGE feature
> correctly raises EOPNOTSUPP when unsupported filesystem is used.
> In particular, filesystems which don't support copy-on-write.

This test, merged as [1] fails on bcachefs:

$ cd testcases/kernel/syscalls/ioctl/
# # LTP_SINGLE_FS_TYPE=bcachefs ./ioctl_ficlone02
tst_buffers.c:57: TINFO: Test is using guarded buffers
tst_tmpdir.c:316: TINFO: Using /tmp/LTP_iocu1xhKp as tmpdir (tmpfs filesystem)
tst_device.c:96: TINFO: Found free device 0 '/dev/loop0'
tst_test.c:1806: TINFO: LTP version: 20240524-131-gdfb293ee0
tst_test.c:1650: TINFO: Timeout per run is 0h 00m 30s
tst_supported_fs_types.c:161: TINFO: WARNING: testing only bcachefs
tst_supported_fs_types.c:97: TINFO: Kernel supports bcachefs
tst_supported_fs_types.c:62: TINFO: mkfs.bcachefs does exist
tst_test.c:1746: TINFO: === Testing on bcachefs ===
tst_test.c:1111: TINFO: Formatting /dev/loop0 with bcachefs opts='' extra opts=''
tst_test.c:1123: TINFO: Mounting /dev/loop0 to /tmp/LTP_iocu1xhKp/mnt fstyp=bcachefs flags=0
ioctl_ficlone02.c:33: TFAIL: ioctl(dst_fd, FICLONE, src_fd) succeeded
ioctl_ficlone02.c:34: TFAIL: ioctl(dst_fd, FICLONERANGE, clone_range) expected EOPNOTSUPP: EINVAL (22)

I tested only kernel 6.10 and 6.9, fails on both. Maybe it's just a different
errno set...

Kind regards,
Petr

[1] https://github.com/linux-test-project/ltp/commit/d70bfb185c9aa52aeab9b9893055eec7fc969a4f

