Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 571132033F;
	Thu, 18 Jan 2024 10:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705573414; cv=none; b=m/TwKzar7vW5jgKs9AFAtCYFK2rCUO5m2BD4lIzcS6kVtp2DUZAVVs/ZwJWiFjjS0iEYaHZ6QASq/V19fLjg1PqN1j+cHHJ8l+qeL9ZgmCk1dz7Lx9Q4cFOIs4NJlUoQbvZpvimZd7RJXf6uJrpb6gZOFyAGZRbLEZFDqSx0MLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705573414; c=relaxed/simple;
	bh=i44Q+tO21nRCte8LK3OdO9IToapy9RIxLpHeddgpllc=;
	h=Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:Reply-To:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To:X-Spam-Level:X-Spam-Score:
	 X-Spamd-Result:X-Spam-Flag; b=Uq9coSELmxrQRr/SZif4h2rvUGUvB+58TRUaWo+sDQG1z5mLwCQh5q5UBn4tfZFYV0Iw3TvvBffT73lJHXFgzGA+dNZMmIaBlZqrN61ryXBXSqJfcwwOxYTQ49Vw6/HHBr7UKI3zKhZl8zRRZz7vb1b85Q2R+S+ZUCezxX//exE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=jYySnjWF; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=5bIVcwHI; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=jYySnjWF; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=5bIVcwHI; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="jYySnjWF";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="5bIVcwHI";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="jYySnjWF";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="5bIVcwHI"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4AF061F789;
	Thu, 18 Jan 2024 10:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1705573410;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=i44Q+tO21nRCte8LK3OdO9IToapy9RIxLpHeddgpllc=;
	b=jYySnjWFhjd4HAE62Qd8i3FzPLs33l+8/C3YD0HgL39bqTy9uP+Ml3SQLumoztE+v9Yl6P
	P1MmlYyOKHvq2zy5ClT9bd8X+pRJn6pcVjhlVM92ePRnJNf/wmeRPvOs+3FhXWtqSktXQi
	tjfXqIGm7n10otjBLN8xHHLv2zh5XB0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1705573410;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=i44Q+tO21nRCte8LK3OdO9IToapy9RIxLpHeddgpllc=;
	b=5bIVcwHI/XAxQvDdWcUdIKUZwOqaNMJJyvd10E5D89JjBxRe9tayS85rqE8Gzl2Um3gXug
	nLqjt5Rd6EzTnVCQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1705573410;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=i44Q+tO21nRCte8LK3OdO9IToapy9RIxLpHeddgpllc=;
	b=jYySnjWFhjd4HAE62Qd8i3FzPLs33l+8/C3YD0HgL39bqTy9uP+Ml3SQLumoztE+v9Yl6P
	P1MmlYyOKHvq2zy5ClT9bd8X+pRJn6pcVjhlVM92ePRnJNf/wmeRPvOs+3FhXWtqSktXQi
	tjfXqIGm7n10otjBLN8xHHLv2zh5XB0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1705573410;
	h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
	 cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=i44Q+tO21nRCte8LK3OdO9IToapy9RIxLpHeddgpllc=;
	b=5bIVcwHI/XAxQvDdWcUdIKUZwOqaNMJJyvd10E5D89JjBxRe9tayS85rqE8Gzl2Um3gXug
	nLqjt5Rd6EzTnVCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8FD9E136F5;
	Thu, 18 Jan 2024 10:23:29 +0000 (UTC)
Received: from dovecot-director2.suse.de ([10.150.64.162])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id SFRkISH8qGVbSwAAD6G6ig
	(envelope-from <pvorel@suse.cz>); Thu, 18 Jan 2024 10:23:29 +0000
Date: Thu, 18 Jan 2024 11:23:28 +0100
From: Petr Vorel <pvorel@suse.cz>
To: Cyril Hrubis <chrubis@suse.cz>
Cc: ltp@lists.linux.it, Li Wang <liwang@redhat.com>,
	Jan Stancek <jstancek@redhat.com>, Xiao Yang <yangx.jy@fujitsu.com>,
	Yang Xu <xuyang2018.jy@fujitsu.com>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Brian Foster <bfoster@redhat.com>, linux-bcachefs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: Re: [PATCH 1/1] tst_supported_fs_types: Disable FUSE bcachefs
Message-ID: <20240118102328.GA2757244@pevik>
Reply-To: Petr Vorel <pvorel@suse.cz>
References: <20240118090004.2748107-1-pvorel@suse.cz>
 <Zaj37NxCU3sIQfrH@yuki>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Zaj37NxCU3sIQfrH@yuki>
Authentication-Results: smtp-out2.suse.de;
	none
X-Spam-Level: 
X-Spam-Score: -3.24
X-Spamd-Result: default: False [-3.24 / 50.00];
	 ARC_NA(0.00)[];
	 HAS_REPLYTO(0.30)[pvorel@suse.cz];
	 REPLYTO_EQ_FROM(0.00)[];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 NEURAL_HAM_LONG(-1.00)[-1.000];
	 MIME_GOOD(-0.10)[text/plain];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 RCVD_COUNT_THREE(0.00)[3];
	 DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	 NEURAL_HAM_SHORT(-0.20)[-1.000];
	 RCPT_COUNT_SEVEN(0.00)[10];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 MID_RHS_NOT_FQDN(0.50)[];
	 RCVD_TLS_ALL(0.00)[];
	 BAYES_HAM(-2.74)[98.89%]
X-Spam-Flag: NO

Hi Li, Cyril,

thanks, merged.

Kind regards,
Petr
