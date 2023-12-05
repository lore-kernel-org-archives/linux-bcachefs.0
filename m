Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="dEHpO/AZ"
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72267183
	for <linux-bcachefs@vger.kernel.org>; Tue,  5 Dec 2023 11:12:23 -0800 (PST)
Date: Tue, 5 Dec 2023 14:12:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1701803541;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nprdprJjkbP65NCo1waE7I0hbZGemLfuJ2g9oRFUf4I=;
	b=dEHpO/AZ4gP9OX8ItBh0bZ2uC78dF4oxr56NLK3WRYt0clP38ZoROHKJtZzT2AyG969YFY
	giDCCzLMrz0u9hGD8baV7MGuVzVs3maUxaTt727J0U//C7BlmA8AFCvc+E0jQed0/AtgkL
	zfDUedDAW3G0/s+cxnOVgAUonUa12aY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: Brian Foster <bfoster@redhat.com>
Cc: linux-bcachefs@vger.kernel.org
Subject: Re: [PATCH 1/2] bcachefs: don't attempt rw on unfreeze when shutdown
Message-ID: <20231205191204.62h3mnealbqdnyjv@moria.home.lan>
References: <20231205132439.130755-1-bfoster@redhat.com>
 <20231205132439.130755-2-bfoster@redhat.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231205132439.130755-2-bfoster@redhat.com>
X-Migadu-Flow: FLOW_OUT

On Tue, Dec 05, 2023 at 08:24:38AM -0500, Brian Foster wrote:
> The internal freeze mechanism in bcachefs mostly reuses the generic
> rw<->ro transition code. If the fs happens to shutdown during or
> after freeze, a transition back to rw can fail. This is expected,
> but returning an error from the unfreeze callout prevents the
> filesystem from being unfrozen.
> 
> Skip the read write transition if the fs is shutdown. This allows
> the fs to unfreeze at the vfs level so writes will no longer block,
> but will still fail due to the emergency read-only state of the fs.
> 
> Signed-off-by: Brian Foster <bfoster@redhat.com>

Applied
