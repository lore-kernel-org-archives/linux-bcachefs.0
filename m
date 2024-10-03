Received: from fout-a2-smtp.messagingengine.com (fout-a2-smtp.messagingengine.com [103.168.172.145])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F6971CFBC;
	Thu,  3 Oct 2024 15:17:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=103.168.172.145
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727968634; cv=none; b=d3kkYKcYSuKDiEoSnPsjeJg2uzvTxN6D29ec1ARpuHt+pwN4mkAcScr0JkskTGWeMIMHU5GDn2fIDnHoHiEY3/Ex3l0UcXXfMgld6hF7DqOwIDTFu8o4z633lTNAlZscgIPvMqgxUtMIF+W1i1vqowgbIPn/x28eIOIb1xtixeg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727968634; c=relaxed/simple;
	bh=QPLylLtyYkLfzTsbDmxLEfA31cTvatRW12QwLlJBq8s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=RyWjOegWK/GL/2yts3fXyOXnIGi2glmQsG5TK4NaYHBlNIXvHPBHba8cSU8Sy2c+ea/sza2JHkVM+9HxgP4UX7pgwJw+khUY+nvY1uF1g2L4ETlS79o30+xM3fo2jf+w3tCznRir1E6dS7f5Xc/9cRfyF1EdtlYeZptodRs89W0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jfarr.cc; spf=pass smtp.mailfrom=jfarr.cc; dkim=pass (2048-bit key) header.d=jfarr.cc header.i=@jfarr.cc header.b=MIdZNFj2; dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b=T6U2LqQ8; arc=none smtp.client-ip=103.168.172.145
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=jfarr.cc
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=jfarr.cc
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=jfarr.cc header.i=@jfarr.cc header.b="MIdZNFj2";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="T6U2LqQ8"
Received: from phl-compute-06.internal (phl-compute-06.phl.internal [10.202.2.46])
	by mailfout.phl.internal (Postfix) with ESMTP id 8760C1380237;
	Thu,  3 Oct 2024 11:17:11 -0400 (EDT)
Received: from phl-mailfrontend-01 ([10.202.2.162])
  by phl-compute-06.internal (MEProxy); Thu, 03 Oct 2024 11:17:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jfarr.cc; h=cc
	:cc:content-type:content-type:date:date:from:from:in-reply-to
	:in-reply-to:message-id:mime-version:references:reply-to:subject
	:subject:to:to; s=fm1; t=1727968631; x=1728055031; bh=NbJK2XRbco
	OTqZvfd13nuSSHJGSlT5A6o8ZtRYgV9vc=; b=MIdZNFj2gbMARNLQ8W/Cn9JtYi
	TpTG+nskS21Ae7Q12SxBwMIPJ9fu+iAOYVSQjaTtLMyzpRKJc5YgvRvy/oj34cow
	YrNcFWsKkyfOqGn+mWBZqAJRZRBu/cRUz+fbx17aIPNjCCENuOSFsEFXu598u+Yt
	BoxyzDYaQMKa7nI1B1cWaWvVOv6CMOFVxt5MXDx4D8Lhd2zu/UH+XyR5tl9bft88
	17FqhVYSfJru0DREUo686vbTtSrl2ErRSHQOLBNnyjkZaAkJgQIig6OVJIvN7mgb
	WtcOrW7EJ3qMIssKWy35GdGgJyjZ1mfftomU6rE8cT3F6974sPffArWDaYDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
	fm2; t=1727968631; x=1728055031; bh=NbJK2XRbcoOTqZvfd13nuSSHJGSl
	T5A6o8ZtRYgV9vc=; b=T6U2LqQ8fYE8g4fb42XZId6h5ZQA/RU+iys5AN8OIafb
	sug/QeX5INCkDfZtNSUmMZ4L4z20WkRXqieuqT1cp/J/h7K7IjiXCANL7F+wYoYJ
	zsPPZjeCw5mtBm9KOJuaeevT35e4gok3veLvueD5Eib4FmhKXf5Z2XTbw78DxinY
	QP6Tbs9bVLMHb1FUVWaqz5Vy0Ksq1jvgLE1FS6RREASEVeya/Yz4U+ZvwPW+Kbjz
	2B0Brp9F+a0zJ0yS2A5P12VPvVBhJep1Tv1jKFpesDU2Cecuq4zyjXerEKhyqA+0
	ZIZbMsT1b6M/iYKUFsc+ThJxiIjCCSlpUbj3lfF5ZQ==
X-ME-Sender: <xms:d7X-ZoVJurDRkw9hNSY6R39nO9ro74XT__akaTHlNjAmAddZPzqh1w>
    <xme:d7X-Zsnn8AGYFa2SR9R2R9Qvql71YvxUllV_JOuHRcACnRcIzth5CK_X5yL44R2fz
    F9QXjv7x19IOfFuJEY>
X-ME-Received: <xmr:d7X-ZsaefTYOl9URL4JAt-U2wws3YbEZ9tYyoX1i72tBoW8fOYa_qOhi-Tda4FDWG-Mdk-stQO-yU2nH2sd5H12PEJwt>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeeftddrvddvuddgkeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdggtfgfnhhsuhgsshgtrhhisggvpdfu
    rfetoffkrfgpnffqhgenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnh
    htshculddquddttddmnegfrhhlucfvnfffucdluddtmdenucfjughrpeffhffvvefukfhf
    gggtuggjsehttdertddttddvnecuhfhrohhmpeflrghnucfjvghnughrihhkucfhrghrrh
    cuoehkvghrnhgvlhesjhhfrghrrhdrtggtqeenucggtffrrghtthgvrhhnpefhudffjeev
    tedtteejleekkeekgfeuudetueelvedtgedtueejvdffieeltdegueenucffohhmrghinh
    epghhithhhuhgsrdgtohhmpdhgohgusgholhhtrdhorhhgpdhkvghrnhgvlhdrohhrghdp
    ohhpvghnqdhsthgurdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepkhgvrhhnvghlsehjfhgrrhhrrdgttgdpnhgspghrtghpthhtohep
    ledpmhhouggvpehsmhhtphhouhhtpdhrtghpthhtohepthhhohhrshhtvghnrdgslhhumh
    esthhosghluhigrdgtohhmpdhrtghpthhtohepkhgvvghssehkvghrnhgvlhdrohhrghdp
    rhgtphhtthhopehkvghnthdrohhvvghrshhtrhgvvghtsehlihhnuhigrdguvghvpdhrtg
    hpthhtoheprhgvghhrvghsshhiohhnsheslhhishhtshdrlhhinhhugidruggvvhdprhgt
    phhtthhopehlihhnuhigqdgstggrtghhvghfshesvhhgvghrrdhkvghrnhgvlhdrohhrgh
    dprhgtphhtthhopehlihhnuhigqdhhrghruggvnhhinhhgsehvghgvrhdrkhgvrhhnvghl
    rdhorhhgpdhrtghpthhtoheplhhinhhugidqkhgvrhhnvghlsehvghgvrhdrkhgvrhhnvg
    hlrdhorhhgpdhrtghpthhtoheprghruggssehkvghrnhgvlhdrohhrghdprhgtphhtthho
    pehmohhrsghosehgohhoghhlvgdrtghomh
X-ME-Proxy: <xmx:d7X-ZnXqjWdrNvC8jNWfQytAvO3_iaK6RcTqfbvWwYkXyoKosymgFg>
    <xmx:d7X-Zim2MW5LCcoJgQPnYu2fte2UTTQAhaHscMX6M3Z0qB2r8xHYmw>
    <xmx:d7X-ZscBhpGCjS01XOJ5N06-snzZypQn0ptLEM2lbw2EiyOfKsPx0g>
    <xmx:d7X-ZkEduQMp-oMS2c-UuWW3b0kmF_9_LS4p0VocTnWBByYRCMebcg>
    <xmx:d7X-ZniS9qBbS8QPpRXjk9vdJ1dB7zrVi4E-0xM15FelmpLsmNrDmkfU>
Feedback-ID: i01d149f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 3 Oct 2024 11:17:09 -0400 (EDT)
Date: Thu, 3 Oct 2024 17:17:08 +0200
From: Jan Hendrik Farr <kernel@jfarr.cc>
To: Thorsten Blum <thorsten.blum@toblux.com>
Cc: Kees Cook <kees@kernel.org>, kent.overstreet@linux.dev,
	regressions@lists.linux.dev, linux-bcachefs@vger.kernel.org,
	linux-hardening@vger.kernel.org, linux-kernel@vger.kernel.org,
	ardb@kernel.org, morbo@google.com
Subject: Re: [REGRESSION][BISECTED] erroneous buffer overflow detected in
 bch2_xattr_validate
Message-ID: <Zv61dCaxScXuOjZg@archlinux>
References: <ZvV6X5FPBBW7CO1f@archlinux>
 <3E304FB2-799D-478F-889A-CDFC1A52DCD8@toblux.com>
 <A499F119-5F0C-43FC-9058-7AB92057F9B3@toblux.com>
 <Zvg-mDsvvOueGpzs@archlinux>
 <202409281331.1F04259@keescook>
 <21D2A2BB-F442-480D-8B66-229E8C4A63D3@toblux.com>
 <Zv6BEO-1Y0oJ3krr@archlinux>
 <E8E64A72-3C1C-40D2-9F07-415F6B8F476E@toblux.com>
Precedence: bulk
X-Mailing-List: linux-bcachefs@vger.kernel.org
List-Id: <linux-bcachefs.vger.kernel.org>
List-Subscribe: <mailto:linux-bcachefs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-bcachefs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E8E64A72-3C1C-40D2-9F07-415F6B8F476E@toblux.com>

On 03 15:07:52, Thorsten Blum wrote:
> On 3. Oct 2024, at 13:33, Jan Hendrik Farr <kernel@jfarr.cc> wrote:
> >> [...]
> > 
> > This issue is now fixed on the llvm main branch:
> > https://github.com/llvm/llvm-project/commit/882457a2eedbe6d53161b2f78fcf769fc9a93e8a
> 
> Thanks!
> 
> Do you know if it also fixes the different sizes here:
> https://godbolt.org/z/vvK9PE1Yq

I have a patch for clang that changes the behavior to what gcc does and
what the kernel seems to be expecting right now, you can find it below.

I'm not 100% sure what if the gcc or the clang behavior is currently
correct. However, I'm gonna argue that gcc has it correct.

gcc currently says that the __bdos of struct containing a flexible array
member is:

sizeof(<whole struct>) + sizeof(<flexible array element>) * <count>

clang however does the following:

max(sizeof(<whole struct>), offsetof(<flexible array member>) + sizeof(<flexible array element>) * <count>)


The kernel assumes the gcc behvaior in places like linux/fs/posix_acl.c:

struct posix_acl *
posix_acl_clone(const struct posix_acl *acl, gfp_t flags)
{
	struct posix_acl *clone = NULL;

	if (acl) {
		int size = sizeof(struct posix_acl) + acl->a_count *
		           sizeof(struct posix_acl_entry);
		clone = kmemdup(acl, size, flags);
		if (clone)
			refcount_set(&clone->a_refcount, 1);
	}
	return clone;
}
EXPORT_SYMBOL_GPL(posix_acl_clone);

This is the code that triggers the problem in [1]. The way I see it, this
code should work, as you also allocate struct posix_acl with the same
sizeof(struct posix_acl) + acl->a_count * sizeof(struct posix_acl_entry)
as an argument to malloc (or in-kernel equivalent).

Based on the C standard the size of that object is the size passed to
malloc. See bottom of page 348 [2].


I'll put together another PR to llvm with this fix, just need to
add/change tests.

[1] https://lore.kernel.org/linux-kernel/3D0816D1-0807-4D37-8D5F-3C55CA910FAA@linux.dev/
[2] https://www.open-std.org/jtc1/sc22/wg14/www/docs/n1548.pdf


--
diff --git a/clang/lib/CodeGen/CGBuiltin.cpp b/clang/lib/CodeGen/CGBuiltin.cpp
index d739597de4c8..1d112aededbd 100644
--- a/clang/lib/CodeGen/CGBuiltin.cpp
+++ b/clang/lib/CodeGen/CGBuiltin.cpp
@@ -919,8 +919,7 @@ CodeGenFunction::emitFlexibleArrayMemberSize(const Expr *E, unsigned Type,
   //   2) bdos of the whole struct, including the flexible array:
   //
   //     __builtin_dynamic_object_size(p, 1) ==
-  //        max(sizeof(struct s),
-  //            offsetof(struct s, array) + p->count * sizeof(*p->array))
+  //        sizeof(struct s) + p->count * sizeof(*p->array))
   //
   ASTContext &Ctx = getContext();
   const Expr *Base = E->IgnoreParenImpCasts();
@@ -1052,22 +1051,13 @@ CodeGenFunction::emitFlexibleArrayMemberSize(const Expr *E, unsigned Type,
     // The whole struct is specificed in the __bdos.
     const ASTRecordLayout &Layout = Ctx.getASTRecordLayout(OuterRD);
 
-    // Get the offset of the FAM.
-    llvm::Constant *FAMOffset = ConstantInt::get(ResType, Offset, IsSigned);
-    Value *OffsetAndFAMSize =
-        Builder.CreateAdd(FAMOffset, Res, "", !IsSigned, IsSigned);
 
     // Get the full size of the struct.
     llvm::Constant *SizeofStruct =
         ConstantInt::get(ResType, Layout.getSize().getQuantity(), IsSigned);
 
-    // max(sizeof(struct s),
-    //     offsetof(struct s, array) + p->count * sizeof(*p->array))
-    Res = IsSigned
-              ? Builder.CreateBinaryIntrinsic(llvm::Intrinsic::smax,
-                                              OffsetAndFAMSize, SizeofStruct)
-              : Builder.CreateBinaryIntrinsic(llvm::Intrinsic::umax,
-                                              OffsetAndFAMSize, SizeofStruct);
+    // Add full size of struct and fam size
+    Res = Builder.CreateAdd(SizeofStruct, Res, "", !IsSigned, IsSigned);
   }
 
   // A negative \p IdxInst or \p CountedByInst means that the index lands



