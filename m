Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50C8720B07;
	Thu, 18 Jan 2024 10:05:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705572336; cv=none; b=odxHdPG2gGG03neNTPlF0ggP6T7pROJ9iGps5FnGTHH9EJ656YNn26m8RpZLdgSxTKmQL27Yw6Yq82qEQveGfkCF6MAol6WoUqUwcHsoCCdWaGExOKJXJkslsVL6pIAsV+kHbedTm6T/xomFjmTZsXBTWQpsWU/WF9tTtUc+iIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705572336; c=relaxed/simple;
	bh=iQ5IhtZgLm+rkc5eoGm9hIH3ZDzmZomFvTPndZ9kpjY=;
	h=Received:Received:Received:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spam-Level:X-Rspamd-Server:X-Spamd-Result:
	 X-Spam-Score:X-Rspamd-Queue-Id:X-Spam-Flag; b=a4qOE5E96z96VhROgFEETyzb12Agxa1okFOsoAePhZOad0ighAWKpVmY5AOm0ztwo3ESB7754EuCP6Q9+WMbCCxhVwJ22sT/tK6uiKlIlgNnsMu9b4YyE44tAZycugwtdgriw7UsKvCTnJ86TLYVHUqYdsUv2W4aucsTPYhY7PU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id DA705222AB;
	Thu, 18 Jan 2024 10:05:22 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B9E6B136F5;
	Thu, 18 Jan 2024 10:05:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ABbxK+L3qGXERAAAD6G6ig
	(envelope-from <chrubis@suse.cz>); Thu, 18 Jan 2024 10:05:22 +0000
Date: Thu, 18 Jan 2024 11:05:32 +0100
From: Cyril Hrubis <chrubis@suse.cz>
To: Petr Vorel <pvorel@suse.cz>
Cc: ltp@lists.linux.it, Li Wang <liwang@redhat.com>,
	Jan Stancek <jstancek@redhat.com>, Xiao Yang <yangx.jy@fujitsu.com>,
	Yang Xu <xuyang2018.jy@fujitsu.com>,
	Kent Overstreet <kent.overstreet@linux.dev>,
	Brian Foster <bfoster@redhat.com>, linux-bcachefs@vger.kernel.org,
	fstests@vger.kernel.org
Subject: Re: [PATCH 1/1] tst_supported_fs_types: Disable FUSE bcachefs
Message-ID: <Zaj37NxCU3sIQfrH@yuki>
References: <20240118090004.2748107-1-pvorel@suse.cz>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20240118090004.2748107-1-pvorel@suse.cz>
X-Spam-Level: 
Authentication-Results: smtp-out1.suse.de;
	none
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-4.00 / 50.00];
	 REPLY(-4.00)[]
X-Spam-Score: -4.00
X-Rspamd-Queue-Id: DA705222AB
X-Spam-Flag: NO

Hi!
Reviewed-by: Cyril Hrubis <chrubis@suse.cz>

-- 
Cyril Hrubis
chrubis@suse.cz
