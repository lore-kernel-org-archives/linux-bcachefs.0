Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61C0840BE8;
	Thu, 11 Jan 2024 15:13:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="EIIco/fh";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="MzUmMaRj";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="EIIco/fh";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="MzUmMaRj"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7D1F02201F;
	Thu, 11 Jan 2024 15:13:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1704986027; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4L5jMITFZjA9dEdSCxJ57llc+goj6hxRqSVODn6rIGo=;
	b=EIIco/fhzc5xrell22hF7aiLQLmqgoR7icwTTYcYZncV+Mrvf/S2MF1P8kv8tNplAWKnOR
	j+VxlZW8bp/lebg3MUN7SokpbxVeAdSkpiKt3FSg+i7MqF4urtfTdQaJToHMbZCQmdFrZn
	vlx6crQQOzRDcQrjLXgYOID21sAFDyI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1704986027;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4L5jMITFZjA9dEdSCxJ57llc+goj6hxRqSVODn6rIGo=;
	b=MzUmMaRjS4KONwaIOItrehDr37d4BqP5RCkxPHnVWmdFumvqzueNWIxXk9OYQo0hsrfiuW
	WWq5eFJy9VAf9/DA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1704986027; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4L5jMITFZjA9dEdSCxJ57llc+goj6hxRqSVODn6rIGo=;
	b=EIIco/fhzc5xrell22hF7aiLQLmqgoR7icwTTYcYZncV+Mrvf/S2MF1P8kv8tNplAWKnOR
	j+VxlZW8bp/lebg3MUN7SokpbxVeAdSkpiKt3FSg+i7MqF4urtfTdQaJToHMbZCQmdFrZn
	vlx6crQQOzRDcQrjLXgYOID21sAFDyI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1704986027;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4L5jMITFZjA9dEdSCxJ57llc+goj6hxRqSVODn6rIGo=;
	b=MzUmMaRjS4KONwaIOItrehDr37d4BqP5RCkxPHnVWmdFumvqzueNWIxXk9OYQo0hsrfiuW
	WWq5eFJy9VAf9/DA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 71E92132CF;
	Thu, 11 Jan 2024 15:13:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id I2avG6sFoGXiSAAAD6G6ig
	(envelope-from <pvorel@suse.de>); Thu, 11 Jan 2024 15:13:47 +0000
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Thu, 11 Jan 2024 16:13:47 +0100
From: pvorel <pvorel@suse.de>
To: Petr Vorel <pvorel@suse.cz>
Cc: ltp@lists.linux.it, Cyril Hrubis <chrubis@suse.cz>, Li Wang
 <liwang@redhat.com>, Jan Stancek <jstancek@redhat.com>, Xiao Yang
 <yangx.jy@fujitsu.com>, Yang Xu <xuyang2018.jy@fujitsu.com>, Kent Overstreet
 <kent.overstreet@linux.dev>, Brian Foster <bfoster@redhat.com>,
 linux-bcachefs@vger.kernel.org, fstests@vger.kernel.org
Subject: Re: [PATCH 1/1] safe_macros: Fix bcachefs failure old kernel
In-Reply-To: <20240111150553.1923767-1-pvorel@suse.cz>
References: <20240111150553.1923767-1-pvorel@suse.cz>
User-Agent: Roundcube Webmail
Message-ID: <24ca6ef55b11b485a47515496de01e2c@suse.de>
X-Sender: pvorel@suse.de
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Authentication-Results: smtp-out1.suse.de;
	none
X-Spamd-Result: default: False [-4.83 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 XM_UA_NO_VERSION(0.01)[];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 BAYES_HAM(-0.74)[83.89%];
	 MIME_GOOD(-0.10)[text/plain];
	 REPLY(-4.00)[];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 RCPT_COUNT_SEVEN(0.00)[11];
	 DBL_BLOCKED_OPENRESOLVER(0.00)[suse.cz:email];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 RCVD_TLS_ALL(0.00)[];
	 MID_RHS_MATCH_FROM(0.00)[]
X-Spam-Level: 
X-Spam-Flag: NO
X-Spam-Score: -4.83

Hi,

I'm sorry, I haven't updated the subject, it should have been:
"tst_supported_fs_types: Skip bcachefs on old kernel"

Kind regards,
Petr

On 2024-01-11 16:05, Petr Vorel wrote:
> LTP with bcachefs-tools and kernel < 6.7 fails (more tests):
> 
>     # LTP_SINGLE_FS_TYPE=bcachefs ./chdir01
>     ...
>     tst_supported_fs_types.c:57: TINFO: mkfs.bcachefs does exist
>     tst_test.c:1669: TINFO: === Testing on bcachefs ===
>     tst_test.c:1117: TINFO: Formatting /dev/loop0 with bcachefs opts=''
>     extra opts=''
>     tst_test.c:1131: TINFO: Mounting /dev/loop0 to
>     /tmp/LTP_chdwqhGtZ/mntpoint fstyp=bcachefs flags=0
>     tst_test.c:1131: TBROK: mount(/dev/loop0, mntpoint, bcachefs, 0, 
> (nil))
>     failed: ENODEV (19)
> 
> The problem is that on FUSE support we expect there is FUSE bcachefs
> implementation. bcachefs supports fusemount, but let's skip testing 
> atm.
> 
> Fixes: 94802606e ("lib: Add support bcachefs filesystem to 
> .all_filesystems")
> Signed-off-by: Petr Vorel <pvorel@suse.cz>
> ---
> Hi all,
> 
> I'm sorry, although man bcachefs(8) mentions fusemount, I haven't
> figured out how to mount filesystem. Am I missing something?
> 
> Also, maybe for the start I would prefer to to test just kernel
> functionality (no fuse).
> 
> Kind regards,
> Petr
> 
>  lib/tst_supported_fs_types.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/lib/tst_supported_fs_types.c 
> b/lib/tst_supported_fs_types.c
> index 369836717..21765c370 100644
> --- a/lib/tst_supported_fs_types.c
> +++ b/lib/tst_supported_fs_types.c
> @@ -96,6 +96,11 @@ static enum tst_fs_impl has_kernel_support(const
> char *fs_type)
> 
>  	SAFE_RMDIR(template);
> 
> +	if (!strcmp(fs_type, "bcachefs") && tst_kvercmp(6, 7, 0) < 0) {
> +		tst_res(TINFO, "bcachefs skipped on kernel < 6.7");
> +		return TST_FS_UNSUPPORTED;
> +	}
> +
>  	/* Is FUSE supported by kernel? */
>  	if (fuse_supported == -1) {
>  		ret = open("/dev/fuse", O_RDWR);
