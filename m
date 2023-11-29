Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="g08wS+Lc"
Received: from out-170.mta1.migadu.com (out-170.mta1.migadu.com [95.215.58.170])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4EA6B12F
	for <linux-bcachefs@vger.kernel.org>; Wed, 29 Nov 2023 13:13:00 -0800 (PST)
Date: Wed, 29 Nov 2023 16:12:54 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1701292378;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=j6B/ppfbw4nVXEGkOzTBY61+qsKBAI4aamGlzoAAChk=;
	b=g08wS+LcBoeVtI3QYrYcOsZQXBygvg5pMvS+dVnu6jxoEA+GXUqudxD23qKR5gzB8//Lxi
	F2IVANic5JJvOm5/Jl4BTG4DtwivVoETi48bAzvTDApA5+M7Oxdc1uQ8TMh60nvJ7DFYFg
	bJrkjK7Fhs33eiTginub9jRpgc4v2fI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Kent Overstreet <kent.overstreet@linux.dev>
To: "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc: Brian Foster <bfoster@redhat.com>, linux-bcachefs@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-hardening@vger.kernel.org,
	Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH][next] bcachefs: Replace zero-length arrays with
 flexible-array members
Message-ID: <20231129211254.45yu4ghc2wg5d4w5@moria.home.lan>
References: <ZWYv/ywR/qxUhVSU@work>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZWYv/ywR/qxUhVSU@work>
X-Migadu-Flow: FLOW_OUT

On Tue, Nov 28, 2023 at 12:22:55PM -0600, Gustavo A. R. Silva wrote:
> Fake flexible arrays (zero-length and one-element arrays) are
> deprecated, and should be replaced by flexible-array members.
> 
> So, replace zero-length arrays with flexible-array members
> in multiple structures.
> 
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>

There are some ZLAs I hadn't converted because they led to new warnings
- in particular, array of flexible members.

I don't think that applies to any of the ones you changed
(replicas_delta_list, maybe?) - but it's something we need to figure
out if we're getting serious about this.
