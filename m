Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3E4D2C6AD
	for <linux-bcachefs@vger.kernel.org>; Fri,  8 Mar 2024 05:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709874205; cv=none; b=Ty0dBs3BwXog2uhWBC96zTx+yWTIfDRULEwhoL5OvlM8BZlQFehd2/HBR/hz9yuPjCoUhsCVI4LBN5ZcPocW+XKNgFkQ/mHNAIM3H2S9Kx9KeVaH2m8K2t1yl2bVAh6MoCc4URiXMNUT47y8V+AgG1Xastt2/irM2V5i4ut+alI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709874205; c=relaxed/simple;
	bh=yX+xRTLfEct+8uswEj8HF/jRBFVAKp0+EgtSenDq9Jk=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mnnqkK5pajTunq8A0BHB6wPc4HJGGTisG83ciNjvxmprmcsZJKYgtmGX86qOZ+TXOTHu+hLQFbbrZrW01ak0vlNb+K5oIMON/xBKzrmISsfIUjz+qvV63W0K11hMBtFzUzASi334qIMeeHNpZGVoQhLgqLWpSQUV2YAmFPXiWkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=JfeXTf/a; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=voxdR0SQ; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=Dcsy8yOL; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Nag4q8VT; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="JfeXTf/a";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="voxdR0SQ";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="Dcsy8yOL";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Nag4q8VT"
Received: from imap2.dmz-prg2.suse.org (imap2.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:98])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id CF1BB6134B;
	Fri,  8 Mar 2024 03:59:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1709870380; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vR92AfeYytpKVRpFW7l2eLSF27go8K4V6fXc4cP3HOM=;
	b=JfeXTf/aXgFZ/TWLfbDm5pZuDUhb/fC4+ZiQ2khKWH+ciJxX6ZHVTOFSSl07v6x63goFvt
	szflYWAxEoZV4F84B3Z6iQLIvMKu6ghKixd7IZSHYRyW+FmmCcU4wirN97LAeyiWt+a7GZ
	0Ranot82GoZq1l+0ERbifObXZiCZs5Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1709870380;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vR92AfeYytpKVRpFW7l2eLSF27go8K4V6fXc4cP3HOM=;
	b=voxdR0SQzBc0M8myOlOTLrnr/oYrQ/zAw46V72rMD0Le9FZLx2JIz9Eh6fsHB/W2HmWvj0
	+Qt8fUvNriGbfLDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1709870379; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vR92AfeYytpKVRpFW7l2eLSF27go8K4V6fXc4cP3HOM=;
	b=Dcsy8yOL/klOMbV4zxeKrIVZMFUX3cnm/E2FhaRKHQTbnxp9Y0jdmlMK73E1ohhtIxvL9u
	Yqocf2blgtnQapjQ11fWqYZrLrfFZ4OInLtciwSpn+KYXol/3aMpvH8vkmnutFqjk1DbpE
	DondlJn4aS9LKsxPxm2Xc81WPUgAOW0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1709870379;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=vR92AfeYytpKVRpFW7l2eLSF27go8K4V6fXc4cP3HOM=;
	b=Nag4q8VT0UxLEGYog/fotqqDi4avXQhtTZIV1ozqKB8DOWNLvqKNxaihc4qmnvRtUhjfjA
	3++HcK4/HNJv7fCg==
Received: from imap2.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap2.dmz-prg2.suse.org (Postfix) with ESMTPS id 7DB3A13A5D;
	Fri,  8 Mar 2024 03:59:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap2.dmz-prg2.suse.org with ESMTPSA
	id ukWACyqN6mUdewAAn2gu4w
	(envelope-from <ddiss@suse.de>); Fri, 08 Mar 2024 03:59:38 +0000
Date: Fri, 8 Mar 2024 14:59:26 +1100
From: David Disseldorp <ddiss@suse.de>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH] make-release-tarball.sh: run cargo audit
Message-ID: <20240308145926.0b7f7ef6@echidna>
In-Reply-To: <n6p6xwwrm4rusf2wjrhqromfajixigo5ddc3ma46ch3f3w7jhi@mwl3h25abthd>
References: <20240130070356.8174-1-ddiss@suse.de>
	<n6p6xwwrm4rusf2wjrhqromfajixigo5ddc3ma46ch3f3w7jhi@mwl3h25abthd>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Level: 
Authentication-Results: smtp-out2.suse.de;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Dcsy8yOL;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=Nag4q8VT
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-1.32 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 R_DKIM_ALLOW(-0.20)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 NEURAL_HAM_LONG(-1.00)[-1.000];
	 MIME_GOOD(-0.10)[text/plain];
	 DWL_DNSWL_BLOCKED(0.00)[suse.de:dkim];
	 NEURAL_HAM_SHORT(-0.20)[-1.000];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 DKIM_TRACE(0.00)[suse.de:+];
	 RCPT_COUNT_TWO(0.00)[2];
	 MX_GOOD(-0.01)[];
	 DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:dkim];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 MID_RHS_NOT_FQDN(0.50)[];
	 RCVD_TLS_ALL(0.00)[];
	 BAYES_HAM(-0.31)[75.26%]
X-Spam-Score: -1.32
X-Rspamd-Queue-Id: CF1BB6134B
X-Spam-Flag: NO

On Thu, 7 Mar 2024 21:16:02 -0500, Kent Overstreet wrote:

> On Tue, Jan 30, 2024 at 06:03:56PM +1100, David Disseldorp wrote:
> > cargo audit can be used to check bcachefs dependencies for
> > vulnerabilities published in the advisory database at
> > https://github.com/RustSec/advisory-db.git
> > 
> > Given the significant size of dependency sources (currently ~292M),
> > manual audit is mostly unviable, so rely on this for now.  
> 
> Not a good place for this, workflow-wise; I run make-release-tarball.sh
> after the new release is tagged and frequently after the tag is
> uploaded.
> 
> This would better be run as some sort of cron job that emails results to
> the list when something is found.

Fair enough, will set something up as part of the downstream (openSUSE)
release process.
