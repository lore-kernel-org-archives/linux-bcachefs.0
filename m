Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="w04Ar2ko"
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [IPv6:2001:41d0:1004:224b::ad])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDD0DA7
	for <linux-bcachefs@vger.kernel.org>; Wed, 13 Dec 2023 10:09:59 -0800 (PST)
Date: Wed, 13 Dec 2023 13:09:55 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1702490998;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=yHxYhZr9xInZEeuw9BtSYZ/9pbx5o6ghyBKZzyJUQQ0=;
	b=w04Ar2koZOqfDUaU3kNn60pe6DBP2E6XS8Hq+woknIYNJqjZvN6KBn1aYuUZeXKw6yJQYK
	SxyTScBunbH8D4AJ6sxDsGcJpTJHE1m9Vo90S5PilugBnvw1tardv66Y7DhESvToyKPrlF
	Up/ftFA3ZrVeRs7njIyb779UhFM2bQE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Jan Kara <jack@suse.cz>
Cc: Brian Foster <bfoster@redhat.com>, linux-bcachefs@vger.kernel.org,
	Petr Vorel <pvorel@suse.cz>
Subject: Re: [PATCH] bcachefs: Fix determining required file handle length
Message-ID: <20231213180955.roc7a6ppdze5xumh@moria.home.lan>
References: <20231213165104.19716-1-jack@suse.cz>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231213165104.19716-1-jack@suse.cz>
X-Migadu-Flow: FLOW_OUT

On Wed, Dec 13, 2023 at 05:51:04PM +0100, Jan Kara wrote:
> The ->encode_fh method is responsible for setting amount of space
> required for storing the file handle if not enough space was provided.
> bch2_encode_fh() was not setting required length in that case which
> breaks e.g. fanotify. Fix it.
> 
> Reported-by: Petr Vorel <pvorel@suse.cz>
> Signed-off-by: Jan Kara <jack@suse.cz>

Thanks! Applied.
