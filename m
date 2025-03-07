Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7486C21C17E
	for <linux-bcachefs@vger.kernel.org>; Fri,  7 Mar 2025 14:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741358697; cv=none; b=ZyRKcLqiF2JWMG+SPSf/9gt5UZflv3oeT2kU9E0K2tb8BeUIU5Hg3aI3NwoFq/paIR3tfiMCOXwbiF/gkN3aAvAL9gCLw0GitlmKJoM1t1XPbJpmSF2BKVKq4F6SomgMqp7AqQXmEQ6qX81QxmAEQA+8yr/dX5prCHJmv5cN22Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741358697; c=relaxed/simple;
	bh=K7t9dY+nh12KijOjgnCLrP+GspnzQ29wp6brHMN7oPI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=luA9N9lWuvQxm8kkxoAuhRmRGLZhKxa2LoUqApU/gtVeb5TjWuPW6o/hcI2bsnes63L6kR6gJqw2UUjYptZ0waPZKr4DX1rckgn5OT5uwf6T+YsOptfLrFSPu/txaqY9mfUpRq8iflfO0SeU51dCxOp/uICSCv0kQDPWDnA/5yI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=n/llTaxo; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=lN9zY8ox; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=n/llTaxo; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=lN9zY8ox; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="n/llTaxo";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="lN9zY8ox";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="n/llTaxo";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="lN9zY8ox"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 97CE721186;
	Fri,  7 Mar 2025 14:44:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1741358694; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=C2uC1jpoTkgilVEYFEfAMTD+YDfOcoaz54txYRkx9kI=;
	b=n/llTaxoR8gCjsFQ/rb5vtcXGfGRuqZ+c28qK24hOdnLNJZGLcxkJNIUOBOLf+2oepvlO8
	nuc1AxWdxgetACUOeWoCAum4J5El+7sCgfh/TBvam03e8W4YzstMw48/LQOSesl9NE8oq6
	+Iryl3nomYFmfnTEnin1kMxnza/JILk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1741358694;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=C2uC1jpoTkgilVEYFEfAMTD+YDfOcoaz54txYRkx9kI=;
	b=lN9zY8oxmsOAbsS6hblOyaWa5FXCbZTQ3E1MCxhd7h8GDAgESvcx63uBrbak2AQ9NS2OxB
	yjEV/9tjgC6bIYBw==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1741358694; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=C2uC1jpoTkgilVEYFEfAMTD+YDfOcoaz54txYRkx9kI=;
	b=n/llTaxoR8gCjsFQ/rb5vtcXGfGRuqZ+c28qK24hOdnLNJZGLcxkJNIUOBOLf+2oepvlO8
	nuc1AxWdxgetACUOeWoCAum4J5El+7sCgfh/TBvam03e8W4YzstMw48/LQOSesl9NE8oq6
	+Iryl3nomYFmfnTEnin1kMxnza/JILk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1741358694;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=C2uC1jpoTkgilVEYFEfAMTD+YDfOcoaz54txYRkx9kI=;
	b=lN9zY8oxmsOAbsS6hblOyaWa5FXCbZTQ3E1MCxhd7h8GDAgESvcx63uBrbak2AQ9NS2OxB
	yjEV/9tjgC6bIYBw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8F53813939;
	Fri,  7 Mar 2025 14:44:54 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ffT7ImYGy2dhMQAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 07 Mar 2025 14:44:54 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 64752A087F; Fri,  7 Mar 2025 15:44:50 +0100 (CET)
Date: Fri, 7 Mar 2025 15:44:50 +0100
From: Jan Kara <jack@suse.cz>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: linux-bcachefs@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 1/7] fs: export invalidate_inodes()
Message-ID: <nfdw5bpwvgl2beynlpp7zwjiy3kglk3s5zbouygotvuy3x2uoo@lkhzxvky2ii4>
References: <20250307134933.1033872-1-kent.overstreet@linux.dev>
 <20250307134933.1033872-2-kent.overstreet@linux.dev>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250307134933.1033872-2-kent.overstreet@linux.dev>
X-Spam-Level: 
X-Spamd-Result: default: False [-3.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	MISSING_XM_UA(0.00)[];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_THREE(0.00)[3];
	FROM_HAS_DN(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	FROM_EQ_ENVFROM(0.00)[];
	RCPT_COUNT_FIVE(0.00)[6];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,suse.cz:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Score: -3.80
X-Spam-Flag: NO

On Fri 07-03-25 08:49:25, Kent Overstreet wrote:
> Needed in bcachefs for implementing blk_holder_ops.mark_dead, since we
> can't use the standard fs holder ops (whicth assume a single block device
> filesystem).
> 
> Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> Cc: Christian Brauner <brauner@kernel.org>
> Cc: Jan Kara <jack@suse.cz>
> Signed-off-by: Kent Overstreet <kent.overstreet@linux.dev>

Please use evict_inodes(). It is exactly the same and is actually already
exported. Since you are the second one in last month to ask for this let's
clean this up [1].

								Honza

[1] https://lore.kernel.org/20250307144318.28120-2-jack@suse.cz

> ---
>  fs/inode.c         | 1 +
>  fs/internal.h      | 1 -
>  include/linux/fs.h | 1 +
>  3 files changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/inode.c b/fs/inode.c
> index 5587aabdaa5e..6364779a7006 100644
> --- a/fs/inode.c
> +++ b/fs/inode.c
> @@ -939,6 +939,7 @@ void invalidate_inodes(struct super_block *sb)
>  
>  	dispose_list(&dispose);
>  }
> +EXPORT_SYMBOL_GPL(invalidate_inodes);
>  
>  /*
>   * Isolate the inode from the LRU in preparation for freeing it.
> diff --git a/fs/internal.h b/fs/internal.h
> index e7f02ae1e098..7cb515cede3f 100644
> --- a/fs/internal.h
> +++ b/fs/internal.h
> @@ -207,7 +207,6 @@ bool in_group_or_capable(struct mnt_idmap *idmap,
>   * fs-writeback.c
>   */
>  extern long get_nr_dirty_inodes(void);
> -void invalidate_inodes(struct super_block *sb);
>  
>  /*
>   * dcache.c
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index be3ad155ec9f..5196317598ac 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -3251,6 +3251,7 @@ extern void unlock_new_inode(struct inode *);
>  extern void discard_new_inode(struct inode *);
>  extern unsigned int get_next_ino(void);
>  extern void evict_inodes(struct super_block *sb);
> +extern void invalidate_inodes(struct super_block *sb);
>  void dump_mapping(const struct address_space *);
>  
>  /*
> -- 
> 2.47.2
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
